ENV["RACK_ENV"] ||= "development"

require 'ext/deep_merge'

require 'rubygems'
require 'bundler'
Bundler.setup(:default, ENV["RACK_ENV"].to_sym)
