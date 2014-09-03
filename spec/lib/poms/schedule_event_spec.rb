require 'spec_helper'

describe Poms::ScheduleEvent do
  let(:poms_broadcast) { Fabricate(:poms_broadcast) }
  let(:schedule_event) {poms_broadcast.schedule_events.first}

  it 'sets the start time' do
    schedule_event.starts_at.should eq(Time.parse '2013-05-28 18:08:55 +0200')
  end

  it 'knows the end time' do
    schedule_event.ends_at.should eq(Time.parse '2013-05-28 18:26:24 +0200')
  end

end
