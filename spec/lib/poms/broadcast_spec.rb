require 'spec_helper'

describe Poms::Broadcast do

  let(:poms_broadcast) { Fabricate(:poms_broadcast) }
  # pippi langkous is a peculiar case, as it has no series, just a season
  let(:poms_pippi_langkous) { Fabricate(:poms_broadcast_pippi_langkous) }

  it 'correctly sets the series' do
    poms_broadcast.serie_mid.should eq('POMS_S_KRO_059857')
  end

  it 'correctly sets the title' do
    poms_broadcast.title.should eq('VRijland afl.64 & 65 (herhaling)')
  end

  it 'correctly sets the description' do
    description = "Li biedt Barry een baantje aan bij de uitdragerij en vraagt zich meteen af of dat wel zo slim was. Timon en Joep zien de criminele organisatie de Rijland Angels. Timon wil naar hun loods, maar is dat wel een goed idee?"
    poms_broadcast.description.should eq(description)
  end

  it 'converts schedule events to Poms::ScheduleEvent'  do
    poms_broadcast.schedule_events.each do |e|
      e.class.should eq(Poms::ScheduleEvent)
    end
  end

  it 'correctly sets available until' do
    poms_broadcast.available_until.should eq(Time.at(1369758599).to_datetime)
  end

  it 'sets the serie correctly when a broadcast only has a season, no series' do
    poms_pippi_langkous.serie_mid.should eq('POW_00107959')
  end

  it 'returns the available streams' do
    poms_broadcast.odi_streams.should eq(["adaptive", "h264_sb", "h264_bb", "h264_std", "wvc1_std", "wmv_sb", "wmv_bb"])
  end

  it 'return the ancestors of the broadcast' do
    # I use to_set as the order does not matter
    poms_broadcast.ancestor_mids.to_set.should eq(['POMS_S_KRO_059857', 'KRO_1521173'].to_set)
  end
end
