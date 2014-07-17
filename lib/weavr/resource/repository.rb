module Weavr
  class Repository < Resource
    field :base_url,         String
    field :default_base_url, String
    field :latest_base_url,  String
    field :mirrors_list,     Whatever # Fix
    field :os_type,          String
    field :repo_id,          String
    field :repo_name,        String
    field :stack_name,       String
    field :stack_vesion,     String
  end
end
