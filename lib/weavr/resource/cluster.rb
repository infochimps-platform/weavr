module Weavr
  class Cluster < Resource
    field :cluster_id,      Integer
    field :cluster_name,    String
    field :version,         String
    field :desired_configs, Hash       # Fix
    field :requests,        Array, of: Request
    field :services,        Array, of: Service
    field :hosts,           Array, of: Host
    field :configurations,  Array, of: Configuration

    def create
      resource_action(:post, self.class.label => { version: 'HDP-2.1' })
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
      mapping.each_pair do |host, comp|
        role = HostRole.receive(href: File.join(href, 'hosts', host, 'host_components', comp))
        role.create
      end
    end

    def create_config(type, version, properties)
      resource_action(:put, self.class.label => { desired_config: { type: type, tag: version, properties: properties } })
      refresh!
    end

    def delete
      services.each(&:stop)
      resource_action(:delete)
    end
  end
end
