require 'spec_helper'

describe Poms::Builder do

  let(:poms_broadcast) { Fabricate(:poms_broadcast) }

  it 'correctly sets the class of a POMS broadcast hash' do
    poms_broadcast.class.should eq(Poms::Broadcast)
  end

  it 'correctly renames and parses the broadcast\'s schedule_events' do
    poms_broadcast.schedule_events.length.should eq(1)
  end

  it 'correctly converts start times to Time-object' do
    poms_broadcast.schedule_events.first.start.should eq(Time.parse '2013-05-28 18:08:55 +0200')
  end

end
