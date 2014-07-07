module Weavr
  class Service < Resource
    def self.label() 'ServiceInfo' ; end

    field :cluster_name,      String
    field :service_name,      String
    field :maintenance_state, String
    field :state,             String
    field :components,        Array, of: Component

    def create
      resource_action(:post, self.class.label => { service_name: service_name })
    end

    def to_state state
      res = resource_action(:put, RequestInfo: { context: "Transition to #{state}" }, Body: { ServiceInfo: { state: state } })
      Request.receive(res || { })
    end

    def install
      to_state'INSTALLED'
    end

    def stop
      to_state 'INSTALLED'
    end

    def start
      to_state 'STARTED'
    end
  end
end
