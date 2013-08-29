require 'rubygems'
require 'bundler/setup'
require 'fakeweb'
require 'fabrication'
require 'poms' # and any other gems you need

FakeWeb.allow_net_connect = false
