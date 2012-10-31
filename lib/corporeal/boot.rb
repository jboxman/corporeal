ENV["RACK_ENV"] ||= "development"

require 'ext/deep_merge'
require 'rubygems'

begin
	require 'bundler'
	begin
		Bundler.setup(:default, ENV["RACK_ENV"].to_sym)
	rescue Bundler::GemfileNotFound
	end
rescue LoadError
	require File.expand_path('../../../vendor/bundle/bundler/setup', __FILE__)
end
