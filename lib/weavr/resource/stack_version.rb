module Weavr
  class StackVersion < Resource
    def self.label() 'Versions' ; end

    field :stack_name, String
    field :stack_version, String
    field :active, :boolean
    field :min_upgrade_version, String
    field :parent_stack_version, String
    collection :stackServices, StackService, key_method: 'service_name'
    collection :operatingSystems, OperatingSystem, key_method: 'os_type'
  end
end
