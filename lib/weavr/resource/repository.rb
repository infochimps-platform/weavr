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

    def update_base_url url
      resource_action(:post, self.class.label => { base_url: url })
    end
  end
end
