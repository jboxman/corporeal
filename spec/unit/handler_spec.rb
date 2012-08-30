require File.join(File.dirname(__FILE__), "spec_helper")
require 'corporeal/database'
require 'corporeal/handler'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

Corporeal::Database.prepare!(true)

describe 'Handler' do
	include Rack::Test::Methods

	def app
		Corporeal::Handler
	end

	it "test" do
		get '/kick/system/1'
		puts last_response.body
	end
end

