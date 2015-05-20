require 'active_support/core_ext/string/inflections'
require 'faraday'
require 'faraday_middleware'
require 'gorillib/builder'
require 'gorillib/model/type/extended'
require 'logger'
require 'multi_json'
require 'tsort'

require 'weavr/connection'
require 'weavr/error'
require 'weavr/resource'
require 'weavr/resource/class_map'
require 'weavr/response'
require 'weavr/version'
require 'weavr/cli'

module Weavr
  extend self

  def default_configuration
    {
      username:   'admin',
      password:   'admin',
      host:       'localhost',
      port:       8080,
      log_level:  'info',
      log_format: ->(sev, t, prog, msg){ "[%-5s] %s\n" % [sev.downcase, msg] }
    }
  end

  def default_logger(level, formatter)
    logger = Logger.new(STDOUT)
    logger.level = Logger.const_get(level.to_s.upcase)
    logger.formatter = formatter
    logger
  end

  def configure(overrides = {})
    options = default_configuration.merge(overrides)
    set_log options[:logger] || default_logger(options[:log_level], options[:log_format])
    set_connection Connection.new(options)
  end

  def set_connection http
    @connection ||= http
  end

  def connection
    return @connection if @connection
    configure
  end

  def set_log device
    @log ||= device
  end

  def log
    @log
  end

  # Should probably be Cluster.find
  def cluster name
    Cluster.receive connection.resource(:get, "clusters/#{name}")
  end

  def clusters
    Collection.of(Cluster).receive connection.resource(:get, 'clusters')
  end

  # Should probably be Cluster.create
  def create_cluster(name, options = {})
    cluster = Cluster.receive(cluster_name: name, href: File.join('clusters', name))
    cluster.create options
  end

  def create_cluster_from_blueprint(blueprint_name, cluster_name, services_blueprint_filename, cluster_blueprint_filename)
    blueprint = Blueprint.receive(blueprint_name: blueprint_name, href: File.join('blueprints', blueprint_name))
    blueprint.create services_blueprint_filename
    cluster = Cluster.receive(cluster_name: cluster_name, href: File.join('clusters', cluster_name))
    cluster.create_from_blueprint cluster_blueprint_filename
  end

  def create_cluster_from_json(blueprint_name, cluster_name, filename)
    blueprint = Blueprint.receive(blueprint_name: blueprint_name, href: File.join('blueprints', blueprint_name))
    begin
      data = MultiJson.load File.open(filename, 'r')
    rescue Exception => e
      raise e.message, Weavr::BlueprintError
    end
    blueprint.create_from_data data['services']
    cluster = Cluster.receive(cluster_name: cluster_name, href: File.join('clusters', cluster_name))
    cluster.create_from_blueprint_data data['cluster']
  end

  def stacks
    Collection.of(Stack).receive connection.resource(:get, 'stacks')
  end

  def hosts
    Collection.of(Host).receive connection.resource(:get, 'hosts')
  end

  def configure_repository(params = {})
    stack = stacks.items.first.refresh!
    version = stack.versions[params[:version]].refresh!
    os      = version.operating_systems[params[:os]].refresh!
    repo    = os.repositories[params[:repo]].refresh!
    repo.update_base_url params[:url]
    repo.refresh!
  end

end
