module Poms
  module HasBaseAttributes
    module ClassMethods
      
    end
    
    module InstanceMethods
      def title
        @titel ||= titles.first.value rescue nil
      end
      
      def description
        @description ||= descriptions.first.value rescue nil
      end 
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end