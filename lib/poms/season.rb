require 'poms/has_ancestors'

module Poms
  class Season < Poms::Builder::NestedOpenStruct
    include Poms::HasBaseAttributes
    include Poms::HasAncestors

    def related_group_mids
      descendant_of.map &:mid_ref
    end
  end
end
  
