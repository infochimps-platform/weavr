module Weavr
  class Collection < Resource
    def self.of kind
      coll = Class.new(self) do
        field :items, Array, of: kind
      end
      Weavr.const_set("#{kind.to_s.demodulize}Collection", coll)
    end
  end
end
