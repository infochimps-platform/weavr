module Weavr
  class OperatingSystem < Resource
    field :os_type, String
    field :stack_name, String
    field :stack_version, String
    collection :repositories, Repository, key_method: 'repo_id'
  end
end
