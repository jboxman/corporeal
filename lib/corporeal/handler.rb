require 'sinatra/base'
require 'json'

require 'corporeal/data'
require 'corporeal/template'

module Corporeal

	class Handler < Sinatra::Base
		use Rack::CommonLogger

		configure :production, :development do
			enable :logging
		end
		set :public_folder, Config.get('web_path')

		# TODO
		# Add hook for disabling system
		# Add hook for sending out chef_attributes to client
		# Hook for cloning distros, profiles, and specific system

		get '/kick/profile/:id' do
			Data::Profile.first(:id => params[:id])
			status 500
			body 'Not implemented!'
		end

		get '/kick/system/:id' do
			@system = Data::System.first(:id => params[:id])
			if @system
				tpl_path = File.join(
					Config.get('template_path'),
					'kickstart',
					@system.merged_attributes[:kickstart_path])
				if File.exists?(tpl_path)
					tpl = IO.read(tpl_path)
					body Template::Kickstart.render(@system.merged_attributes, tpl)
				else
					status 500
					body 'Template not found!'
				end
			else
				status 404
				body 'Could not find System!'
			end
		end

		# Log success and disable
		get '/hook/success/:id' do
		end

		# Request chef_attributes as JSON
		get '/hook/chef_attributes/:id' do
		end

		# Request kickstart_variables as JSON
		get '/hook/kickstart_variables/:id' do
		end
	end

end
