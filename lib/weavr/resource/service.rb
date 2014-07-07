module Weavr
  class Service < Resource
    def self.label() 'ServiceInfo' ; end

    field :cluster_name,      String
    field :service_name,      String
    field :maintenance_state, String
    field :state,             String
    field :components,        Array, of: Component

    def stop
      resource_action(:put, RequestInfo: { context: 'Stop Service' }, Body: { ServiceInfo: { state:'INSTALLED' } })
    end
  end
end
