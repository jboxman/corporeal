require File.join(File.dirname(__FILE__), "spec_helper")

require 'corporeal/config'
require 'corporeal/database'
require 'corporeal/handler'
require 'corporeal/data'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

Corporeal::Database.prepare!(true)
Corporeal::Config.set('template_root', File.join(File.dirname(__FILE__), '..'))
puts Corporeal::Config.get('template_root')

describe 'Handler' do
	include Rack::Test::Methods

	def app
		Corporeal::Handler
	end
	
	include_context "data_helpers"

	before do
		create_distro("d1")
		create_profile("p1", "d1")
		create_system("s1", "p1")
	end

	it "test" do
		puts Corporeal::Data::System.first(1)[0].merged_attributes.inspect
		get '/kick/system/1'
		puts last_response.body
	end
end

