module Weavr
  class Cluster < Resource
    field :cluster_id,      Integer
    field :cluster_name,    String
    field :version,         String
    field :desired_configs, Hash       # Fix
    field :requests,        Array, of: Request
    field :services,        Array, of: Service
    field :hosts,           Array, of: Host
    field :configurations,  Array, of: Configuration

    def delete
      services.each(&:stop)
      resource_action(:delete)
    end
  end
end
