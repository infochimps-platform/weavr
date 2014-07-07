module Weavr
  class Configuration < Resource
    def self.label() 'Config' ; end

    field :cluster_name, String
    field :tag,          String
    field :type,         String
    field :properties,   Hash
  end
end
