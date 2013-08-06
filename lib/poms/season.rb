require 'poms/has_descendants'

module Poms
  class Season < Poms::Builder::NestedOpenStruct
  	
    include Poms::HasDescendants
   
  end
end
  
