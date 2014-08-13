module Weavr
  class Cluster < Resource
    field :cluster_id,      Integer
    field :cluster_name,    String
    field :version,         String
    field :desired_configs, Hash       # Fix
    collection :requests,   Request, key_method: 'id'
    collection :services,   Service, key_method: 'service_name'
    collection :hosts,      Host,    key_method: 'host_name'
    field :configurations,  Array, of: Configuration

    def create options
      resource_action(:post, self.class.label => { version: 'HDP-2.1' }.merge(options))
      self
    end

    def add_hosts(*names)
      names.each do |name|
        host = Host.receive(href: File.join(href, 'hosts', name))
        host.create
      end
      refresh!
    end

    def add_services(*names)
      names.each do |name|
        srvc = Service.receive(service_name: name, href: File.join(href, 'services'))
        srvc.create
      end
      refresh!
    end

    def add_components(srvc, names)
      names.each do |name|
        comp = Component.receive(component_name: name, href: File.join(href, 'services', srvc, 'components', name))
        comp.create
      end
      refresh!
    end

    def assign_host_components mapping
      mapping.each_pair do |host, comps|
        comps.each do |comp|
          role = HostRole.receive(href: File.join(href, 'hosts', host, 'host_components', comp))
          role.create
        end
      end
    end

    def create_config(type, version, properties)
      resource_action(:put, self.class.label => { desired_config: { type: type, tag: version, properties: properties } })
      refresh!
    end

    # POST /clusters/:name
    # Creates a cluster.
    # example
    # curl -H "X-Requested-By: ambari" -d @hdp_blueprint_cluster.json -u admin:admin \
    #      -XPOST http://localhost:8080/api/v1/clusters/blueprint-hwx
    def create_from_blueprint cluster_blueprint_filename
      begin
        f = File.open(cluster_blueprint_filename, 'r')
      rescue Exception => e
        puts e
        exit 1
      end

      begin
        data = MultiJson.load(f)
      rescue MultiJson::ParseError => e
        puts e.data
        puts e.cause
        exit 1
      end

      resource_action(:post, data)
      self
    end

    # GET /clusters/:name?format=blueprint
    # Export the current cluster layout as a blueprint.
    # TODO: add GET param handling to Weavr::Connection#resource
    def get_blueprint name
      connection.resource(:get, "clusters/#{name}?format=blueprint")
    end

    def delete
      resource_action(:delete)
    end

    # Weird persist method for the browser
    def persist
      connection.resource(:post, 'persist', 'CLUSTER_CURRENT_STATUS' => { 'clusterState' => 'CLUSTER_STARTED_5' }.to_json)
    end
  end
end
