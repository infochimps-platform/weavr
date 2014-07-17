module Weavr
  class Stack < Resource
    field :stack_name, String
    collection :versions, StackVersion, key_method: 'stack_version'
  end
end
