module Weavr
  class Resource
    include Gorillib::Model

    field :href, String

    def self.receive(params, &blk)
      super extract_class_params(params, &blk)
    end

    def self.extract_class_params params
      params.merge params[label]
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

    def refresh!
      receive! connection.connection.get(href).body
      self
    end
  end
end
