require 'poms/has_base_attributes'

module Poms
  class Series < Poms::Builder::NestedOpenStruct
    include Poms::HasBaseAttributes
  end
end
  
