module Weavr
  class Component < Resource
    def self.label() 'ServiceComponentInfo' ; end

    field :component_name,  String
    field :service_name,    String
    field :category,        String
    field :cluster_name,    String
    field :state,           String
    field :host_components, Array, of: HostRole
  end
end
