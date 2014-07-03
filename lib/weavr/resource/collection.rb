module Weavr
  class Collection < Resource    
    def self.of kind
      Class.new(self) do
        field :items, Array, of: kind
      end      
    end
  end
end
