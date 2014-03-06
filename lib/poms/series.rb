require 'poms/has_base_attributes'

module Poms
  class Series < Poms::Builder::NestedOpenStruct
    include Poms::HasBaseAttributes
    
    def related_group_mids
      Poms.fetch_descendants_for_serie(mid, 'SEASON').map &:mid
    end   
  end
end
  
