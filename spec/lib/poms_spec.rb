require 'spec_helper'

describe Poms do
  
  describe 'fetch a broadcast' do
    
    let(:response) { File.read 'spec/fixtures/poms_broadcast.json' }

    before do
      FakeWeb.register_uri(:get, "http://docs.poms.omroep.nl/media/KRO_1614405", :body => response)
    end

    it "fetches a broadcast" do
       Poms.fetch_raw_json('KRO_1614405').should eq(JSON.parse response)
    end

    it "fetches a broadcast and parses it correctly" do
      Poms::Builder.should_receive(:process_hash).with(JSON.parse response)
      Poms.fetch('KRO_1614405')
    end

  end
  

  describe 'fetch all zapp broadcasts' do
    let(:response)    { File.read 'spec/fixtures/poms_zapp.json' }
    let(:start_time)  { Time.parse '2013-05-28 17:32:10 +0200' }
    let(:end_time)    { Time.parse '2013-06-11 17:32:50 +0200' }
    
    before do
      path = "http://docs.poms.omroep.nl/media/_design/media/_view/broadcasts-by-broadcaster-and-start?startkey=[%22Zapp%22,1369755130000]&endkey=[%22Zapp%22,1370964770000]&reduce=false&include_docs=true"
      FakeWeb.register_uri(:get, path, :body => response)
    end

    it "fetches all broadcast by zapp" do
      Poms.upcoming_broadcasts_raw_json('zapp', start_time, end_time).should eq(JSON.parse response)
    end

    it "fetches all broadcast by zapp and parses it correctly" do
      Poms::Builder.should_receive(:process_hash).exactly(136).times
      Poms.upcoming_broadcasts('zapp', start_time, end_time)
    end

  end

end

