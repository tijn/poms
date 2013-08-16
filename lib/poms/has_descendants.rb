module Poms
  module HasDescendants
    module ClassMethods
      
    end
    
    module InstanceMethods
      def series
        return @series if @series
        descendant_series = descendant_of.reject {|obj| obj.class != Poms::Series }
        if descendant_of.blank?
          []
        elsif descendant_series.blank?
          descendant_of
        else
          descendant_series 
        end
      end   

      def serie 
        series.first
      end
      def serie_mid
        return nil if serie.nil?
        serie.mid_ref || serie.mid
      end
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
