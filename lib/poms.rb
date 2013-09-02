require 'active_support'
require 'open-uri'
require 'json'
require 'poms/base'
require 'poms/version'
require 'poms/builder'
require 'poms/schedule_event'
require 'poms/broadcast'
require 'poms/season'
require 'poms/series'

module Poms
  extend self
  URL = 'http://docs.poms.omroep.nl'
  MEDIA_PATH = '/media/'
  BROADCASTS_VIEW_PATH = '/media/_design/media/_view/broadcasts-by-broadcaster-and-start'
  ANCESTOR_AND_TYPE_PATH = '/media/_design/media/_view/by-ancestor-and-type'
  CHANNEL_AND_START_PATH = '/media/_design/media/_view/broadcasts-by-channel-and-start'
  VALID_CHANNELS = /^NED(1|3)$/
  #  ?startkey=[\"Zapp\",1369755130000]&endkey=[\"Zapp\",1370964770000]&reduce=false&include_docs=true

  def fetch(mid)
    return nil if mid.nil?
    hash = fetch_raw_json mid
    Poms::Builder.process_hash hash
  end

  def fetch_raw_json(mid)
    uri = [MEDIA_PATH, mid].join
    get_json(uri)
  end

  def upcoming_broadcasts(zender, start_time = Time.now, end_time = Time.now+7.days)
    hash = upcoming_broadcasts_raw_json(zender, start_time, end_time)
    hash['rows'].map {|item| Poms::Builder.process_hash item['doc']}
  end

  def upcoming_broadcasts_raw_json(zender, start_time=Time.now, end_time=Time.now+7.days)
    uri = [BROADCASTS_VIEW_PATH, broadcast_view_params(zender, start_time, end_time )].join
    get_json(uri)
  end
  

  def fetch_descendants_for_serie(mid, type='BROADCAST')
    hash = fetch_descendants_for_serie_raw_json(mid, type) || {'rows' => []}
    hash['rows'].map {|item| Poms::Builder.process_hash item['doc']}
  end

  def fetch_descendants_for_serie_raw_json(mid, type='BROADCAST')
    uri = [ANCESTOR_AND_TYPE_PATH, ancestor_view_params(mid, type) ].join
    get_json(uri)
  end 
  
  alias_method :fetch_broadcasts_for_serie, :fetch_descendants_for_serie
  alias_method :fetch_broadcasts_for_serie_raw_json, :fetch_descendants_for_serie_raw_json

  def fetch_broadcasts_by_channel_and_start(channel, start_time=1.week.ago, end_time=Time.now)
    uri = [CHANNEL_AND_START_PATH, channel_params(channel, start_time, end_time) ].join
    hash = get_json(uri)
    hash['rows'].map {|item| Poms::Builder.process_hash item['doc']}
  end

  # private
  def broadcast_view_params(zender, start_time, end_time)
    zender = zender.capitalize
    "?startkey=[\"#{zender}\",#{start_time.to_i * 1000}]&endkey=[\"#{zender}\",#{end_time.to_i * 1000}]&reduce=false&include_docs=true"
  end

  def ancestor_view_params(mid, type)
    "?reduce=false&key=[\"#{mid}\",\"#{type}\"]&include_docs=true"
  end

  def channel_params(channel, start_time, end_time)
    "?startkey=[\"#{channel}\",#{start_time.to_i * 1000}]&endkey=[\"#{channel}\",#{end_time.to_i * 1000}]&reduce=false&include_docs=true"
  end

  def get_json(uri)
    begin
      JSON.parse(open(URI.escape [URL, uri].join).read)
    rescue OpenURI::HTTPError => e
      raise e unless e.message.match(/404/)
      nil
    end
  end


end
