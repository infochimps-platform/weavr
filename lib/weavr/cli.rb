module Weavr
  class CLI
    attr_reader :cluster, :log

    def initialize(cluster, options = {})
      @cluster = cluster
      @log = options[:log] || Weavr.log
    end

    #--------------------------------------------------------------------------------
    # REPL
    #--------------------------------------------------------------------------------

    # accepts a command from the user and executes it on the cluster.
    #
    # @param [Weavr::Cluster] cluster a cluster to operate on
    def accept_cmd
      $stdout.write("> ")
      case (cmd = $stdin.readline.strip)
      when /^(start|stop|reconfigure|delete_app_timeline|wait)\s*(.*)/i
        begin
          args = $2.split(/\s+/).map{|x| MultiJson.load(x) rescue x}
          send($1, cluster, *args)
        rescue Interrupt => ex
          $stderr.puts "caught keyboard interrupt. C-c again or 'quit' to exit."
        rescue Weavr::RequestError => ex
          $stderr.puts [ex.message, *ex.backtrace]
        rescue StandardError => ex
          $stderr.puts [ex.message, *ex.backtrace]
        end
      when /^(quit|exit)$/i
        exit 0
      else
        puts "didn't understand that"
      end
    end

    def repl
      loop{accept_cmd}
    end

    #--------------------------------------------------------------------------------
    # interactive Ambari cluster operations
    #--------------------------------------------------------------------------------

    # delete the application timeline server component from the
    # specified host. This is necessary, according to the prompts from
    # Ambari, because the application timeline server isn't set up for
    # Kerberos.
    #
    # @param [Weavr::Cluster] cluster a cluster to operate on
    # @param [String] host a host to delete the ambari app timeline
    #                 from.
    def delete_app_timeline(host)
      cluster.refresh!
      tlhost = cluster.hosts[host]
      tlhost.refresh!
      app_tl = tlhost.host_components['APP_TIMELINE_SERVER']
      if app_tl.nil?
        log.info("already deleted app timeline server.")
      else
        log.info("found #{app_tl}. deleting app timeline server.")
        app_tl.resource_action(:delete)
      end
    end

    # upload new desired conigurations for the specified types. The
    # Ambari properties are drawn from a configurable source (@see
    # #confs) merged with the old properties (see Weavr) and then
    # tagged with a new tag (@see #new_tag). Please see the Ambari
    # documentation for an explanation of configuration tags.
    #
    # After reconfiguring a particular type (which might be hdfs-site,
    # hive-site, global, etc.), the services relying on that type of
    # configuration will have to be stopped and then started via the
    # Ambari API for this to take effect. (@see #stop, @see #start).
    #
    # @param [Weavr::Cluster] cluster
    # @param [Array] types
    def reconfigure(confs, old_tag, new_tag, *types)
      confs_v = confs
      types = confs_v.keys if types.empty?
      
      types.each do |type|
        if !confs_v.keys.include?(type)
          raise ArgumentError.new("unknown type #{type}")
        end
      end

      types.each do |type|
        properties = confs_v[type]

        conf = cluster.configurations.find{|x| x.type == type}.tap(&:refresh!)
        log.debug("properties: #{conf}")
        old_config = conf.properties
        new_config = old_config.merge(properties)
        new_tag_v = new_tag

        log.debug("old properties:")
        old_config.each do |p,v|
          log.debug("  #{p} = #{v}")
        end

        #-----
        log.info "setting properties for #{type}. starting from tag #{old_tag}"
        #-----

        properties.each do |p,v|
          log.info "  setting #{p} = #{v}"
        end
        if properties.all?{|p,v| old_config[p] == v}
          log.info("all properties are already set for #{type}!")
        else
          cluster.create_config(type, new_tag_v, new_config)
        end
      end
    end

    # start the specified services one after another, each time
    # waiting for a service to complete before launching the next.
    #
    # @param [Weavr::Cluster] cluster cluster to operate on
    # @param [Array] services an array of Strings representing Ambari
    #                services
    def start(*services)
      services = cluster.services.keys.dup
      class << services
        def dependencies
          @dependencies ||= {
            'FALCON' => ['HDFS', 'MAPREDUCE2', 'YARN'],
            'GANGLIA' => ['HDFS', 'MAPREDUCE2', 'YARN'],
            'HBASE' => ['HDFS', 'MAPREDUCE2', 'YARN', 'ZOOKEEPER'],
            'HCATALOG' => ['HDFS', 'MAPREDUCE2', 'YARN'],
            'HIVE' => ['HCATALOG', 'HDFS', 'MAPREDUCE2', 'YARN'],
            'NAGIOS' => ['HDFS', 'MAPREDUCE', 'YARN'],
            'OOZIE' => ['HDFS', 'MAPREDUCE', 'YARN'],
            'PIG' => ['HDFS', 'MAPREDUCE', 'YARN'],
            'SQOOP' => ['HDFS', 'MAPREDUCE', 'YARN'],
            'TEZ' => ['HDFS', 'MAPREDUCE', 'YARN'],
            'WEBHCAT' => ['HCATALOG', 'HDFS', 'MAPREDUCE', 'YARN'],
            'YARN' => ['HDFS'],
            'MAPREDUCE2' => ['HDFS'],
            'HDFS' => [],
            'ZOOKEEPER' => [],
          }
        end

        include TSort
        alias tsort_each_node each
        def tsort_each_child(node, &blk)
          select{|k| dependencies.fetch(node).include?(k)}.each(&blk)
        end
      end

      services = services.tsort

      # These always appear to come back as INSTALLED rather than STARTED.
      unstartable_services = %w[HCATALOG PIG SQOOP TEZ]

      log.info "starting services in the following order: #{services}"
      services.each do |s|
        log.info "starting #{s}"
        cluster.services[s].start
        wait('STARTED', s) unless unstartable_services.include? s
      end
    end

    # stop the specified services
    #
    # @param [Weavr::Cluster] cluster cluster to operate on
    # @param [Array] services an array of Strings representing Ambari
    #                services
    def stop(*services)
      cluster.services.each do |s|
        log.info "stopping #{s.service_name}"
        s.stop
      end
    end

    # wait for services to reach expected state.
    #
    # @param [Weavr::Cluster] cluster cluster to operate on
    # @param [Array] services an array
    def wait(expected, *services)
      services = cluster.services.keys.dup if services.empty?
      svcs = services.dup

      log.info "waiting for these services to reach state #{expected}: #{services}"

      loop do
        services.each do |s|
          case (state = cluster.services[s].tap(&:refresh!).state)
          when 'INSTALLED', 'STARTED', 'STARTING', 'STOPPING'
            if state == expected
              svcs.delete(s)
            else
              log.info("#{s} in state #{state}")
            end
          else
            log.fatal("unrecognized service state: #{state} for #{s}")
            exit 1
          end
        end
        break if svcs.empty?
        sleep Settings.ambari_wait_sec
      end
    end
  end
end
