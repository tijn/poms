require 'poms/has_ancestors'

module Poms
  class Season < Poms::Builder::NestedOpenStruct
  	
    include Poms::HasAncestors
   
  end
end
  
