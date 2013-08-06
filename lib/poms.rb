require 'open-uri'
require 'json'
require 'poms/version'
require 'poms/builder'
require 'poms/schedule_event'
require 'poms/broadcast'
require 'poms/season'
require 'poms/series'

module Poms

  URL = 'http://docs.poms.omroep.nl'
  MEDIA_PATH = '/media/'
  BROADCASTS_VIEW_PATH = '/media/_design/media/_view/broadcasts-by-broadcaster-and-start'
  ANCESTOR_AND_TYPE_PATH = '/media/_design/media/_view/by-ancestor-and-type'
  VALID_CHANNELS = /^NED(1|3)$/
  #  ?startkey=[\"Zapp\",1369755130000]&endkey=[\"Zapp\",1370964770000]&reduce=false&include_docs=true

  def self.fetch mid
    return nil if mid.nil?
    hash = self.fetch_raw_json mid
    Poms::Builder.process_hash hash
  end

  def self.fetch_raw_json mid
    uri = [MEDIA_PATH, mid].join
    get_json(uri)
  end

  def self.upcomming_broadcasts zender, start_time = Time.now, end_time = Time.now+7.days
    hash = upcomming_broadcasts_raw_json(zender, start_time, end_time)
    hash['rows'].map {|item| Poms::Builder.process_hash item['doc']}
  end

  def self.upcomming_broadcasts_raw_json zender, start_time=Time.now, end_time=Time.now+7.days
    uri = [BROADCASTS_VIEW_PATH, broadcast_view_params(zender, start_time, end_time )].join
    get_json(uri)
  end

  def self.fetch_broadcasts_for_serie mid
    hash = self.fetch_broadcasts_for_serie_raw_json mid
    hash['rows'].map {|item| Poms::Builder.process_hash item['doc']}
  end

  def self.fetch_broadcasts_for_serie_raw_json mid
    uri = [ANCESTOR_AND_TYPE_PATH, ancestor_view_params(mid) ].join
    get_json(uri)
  end

  
  # private
  def self.broadcast_view_params zender, start_time, end_time
    zender = zender.capitalize
    "?startkey=[\"#{zender}\",#{start_time.to_i * 1000}]&endkey=[\"#{zender}\",#{end_time.to_i * 1000}]&reduce=false&include_docs=true"
  end

  def self.ancestor_view_params(mid)
    "?reduce=false&key=[\"#{mid}\",\"BROADCAST\"]&include_docs=true"
  end

  def self.get_json uri
    JSON.parse(open(URI.escape [URL, uri].join).read)
  end


end
