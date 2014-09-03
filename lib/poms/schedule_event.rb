module Poms
  class ScheduleEvent < Poms::Builder::NestedOpenStruct

    def initialize hash
      @hash = hash
      set_start_and_end_times
      super @hash
    end

    private

    def set_start_and_end_times
      set_starts_at
      set_ends_at
    end

    def set_starts_at
      @hash[:starts_at] = case @hash[:start]
        when String, Integer
          Time.at @hash[:start] / 1000
        when Time
          @hash[:start]
        end
    end

    def set_ends_at
      @hash['ends_at'] = @hash[:starts_at] + duration
    end

    def duration
      (@hash[:duration].to_i / 1000).seconds
    end

  end
end

