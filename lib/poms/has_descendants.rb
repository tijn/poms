module Poms
  module HasDescendants
    module ClassMethods
      
    end
    
    module InstanceMethods
      def series
        return @series if @series
        descendant_series = descendant_of.reject {|obj| obj.class != Poms::Series }
        if descendant_of.blank?
          @series = []
        elsif descendant_series.blank?
          @series = descendant_of
        else
          @series = descendant_series 
        end
        @series
      end   

      def serie 
        series.first
      end
      def serie_mid
        serie.mid_ref || serie.mid
      end
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end