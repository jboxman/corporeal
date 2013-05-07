ENV["RACK_ENV"] ||= "development"

require 'ext/deep_merge'
require 'rubygems'

#
# If Bundler cannot be found, then assume --standalone
#
# `bundle install --standalone --deployment --path=vendor/bundle`
#

begin
	require 'bundler'
	begin
		Bundler.setup(:default, ENV["RACK_ENV"].to_sym)
	rescue Bundler::GemfileNotFound
	end
rescue LoadError
	require File.expand_path('../../../vendor/bundle/bundler/setup', __FILE__)
end
