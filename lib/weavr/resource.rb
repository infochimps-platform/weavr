module Weavr
  class Resource
    include Gorillib::Builder

    field :href, String

    class << self
      def receive(params, &blk)
        super extract_class_params(params, &blk)
      end

      def extract_class_params params
        params.merge(params[label] || {})
      end

      def label
        name.demodulize.pluralize
      end

      def predefine_class name
        Weavr.const_set(name, Class.new(self))
        child_resources << name
      end

      def child_resources
        @resources ||= []
      end

      def load_definitions!
        child_resources.each do |name|
          require File.expand_path("../resource/#{name.underscore}", __FILE__)
        end
      end
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
