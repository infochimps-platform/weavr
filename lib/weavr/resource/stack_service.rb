module Weavr
  class StackService < Resource
    field :service_name, String
    field :stack_name, String
    field :stack_version, String
    field :comments, String
    field :config_types, Array, of: String
    field :service_version, String
    field :user_name, String
    collection :service_components, ServiceComponent, key_method: 'component_name'
    collection :configurations, StackConfiguration, key_method: 'property_name'
  end
end
