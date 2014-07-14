module Weavr
  class Component < Resource
    def self.label() 'ServiceComponentInfo' ; end

    field :component_name,       String
    field :service_name,         String
    field :category,             String
    field :cluster_name,         String
    field :state,                String
    collection :host_components, HostRole, key_method: 'component_name'

    def create
      resource_action(:post)
    end
  end
end
