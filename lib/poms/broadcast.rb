require 'poms/has_descendants'
require 'poms/has_base_attributes'

module Poms
  class Broadcast < Poms::Builder::NestedOpenStruct
    
    include Poms::HasDescendants
    include Poms::HasBaseAttributes

    def initialize hash
      
      super  
      process_schedule_events

    end
   
    def process_schedule_events
      if schedule_events
        schedule_events.select! {|e| e.channel.match Poms::VALID_CHANNELS }
      end
      self.schedule_events = schedule_events.map{|e| Poms::ScheduleEvent.new e.marshal_dump} if schedule_events
    end

    def series_mid
      serie.try :mid_ref || serie.mid
    end

    def available_streams
      return nil if locations.nil? or locations.empty?
      streams = locations.map do |l|
        l.program_url.match(/^[\w+]+\:\/\/[\w\.]+\/video\/(\w+)\/\w+/)[1] 
      end
      streams.uniq
    end

  end
end
  
