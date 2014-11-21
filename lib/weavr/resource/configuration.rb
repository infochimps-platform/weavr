module Weavr
  class Configuration < Resource
    def self.label() 'Config' end

    field :cluster_name, String
    field :tag,          String
    field :type,         String
    field :properties,   Hash

    def receive!(params)
      items = params['items']
      super items.nil? ? params : items.first
    end
  end
end
