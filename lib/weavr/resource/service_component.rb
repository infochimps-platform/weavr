module Weavr
  class ServiceComponent < Resource
    def self.label() 'StackServiceComponents' ; end
    field :cardinality,        Integer
    field :component_category, String
    field :component_name,     String
    field :is_client,          :boolean
    field :is_master,          :boolean
    field :service_name,       String
    field :stack_name,         String
    field :stack_version,      String
    field :dependencies,       Array # Fix
  end
end
