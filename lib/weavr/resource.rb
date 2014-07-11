module Weavr
  class Resource
    include Gorillib::Builder

    field :href, String

    def self.receive(params, &blk)
      super extract_class_params(params, &blk)
    end

    def self.extract_class_params params
      params.merge(params[label] || {})
    end

    def self.label
      name.demodulize + 's'
    end

    def receive! params
      super self.class.extract_class_params(params)
    end

    def connection
      Weavr.connection
    end

    def resource_action(action, data = {})
      connection.resource(action, href, data)
    end

    def refresh!
      receive! resource_action(:get)
      self
    end
  end
end
