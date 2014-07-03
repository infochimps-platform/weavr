module Weavr
  class Task < Resource
    field :cluster_name, String
    field :id,           Integer
    field :request_id,   Integer
  end
end
