require 'sinatra/base'
require 'json'

require 'corporeal/data'
require 'corporeal/template'

module Corporeal

	class Handler < Sinatra::Base

		# TODO
		# Add hook for disabling system
		# Add hook for registering bootif hwaddr
		# Add hook for sending out chef_attributes to client
		# Hook for cloning distros, profiles, and specific system

		get '/kick/profile/:id' do
			Data::Profile.first(:id => params[:id])
		end

		get '/kick/system/:id' do
			@system = Data::System.first(:id => params[:id])
			if @system
				tpl_path = File.join(
					Config.get('template_root'),
					'kickstart',
					'default.ks.erb')
				tpl = IO.read(tpl_path)
				body Template::Kickstart.render(o.merged_attributes, tpl)
			else
				status 404
				body 'Could not find System!'
			end
		end
	end

end