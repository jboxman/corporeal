ENV["RACK_ENV"] ||= "development"

require 'ext/deep_merge'

require 'rubygems'
require 'bundler'

begin
	Bundler.setup(:default, ENV["RACK_ENV"].to_sym)
rescue Bundler::GemfileNotFound
end
