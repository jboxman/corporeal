require 'corporeal/config'
require 'corporeal/data'
require 'corporeal/template'

require 'fileutils'

module Corporeal
	module Util

		class Pixie
			#
			# Need to pull the key parameters and use that to build
			# a menu for profiles && for individual systems.
			# This is going to be someplace like /var/lib/tftp/pxelinux.cfg/*
			#
			# Template base calls with subclasses for PXE && Kickstart things.

			def self.sync
				# Need to do this for individual systems, too, but save
				# to a file based on hwaddr.
				h = {}
				h['items'] = ""
				Data::Profile.all.each do |o|
					tpl_path = File.join(
						Config.get('template_root'),
						'pixie',
						'profile.erb')
					tpl = IO.read(tpl_path)
					t = Template::Pixie.new(o.merged_attributes, tpl)
					h['items'] << t.to_s
				end

				tpl_path = File.join(
					Config.get('template_root'),
					'pixie',
					'default.erb')
				tpl = IO.read(tpl_path)

				Template::Pixie.render_to_file(h, tpl) do |rendered|
					dest = File.join(Config.get('pxe_root'), 'default')
					unless Config.get('via_sudo')
						FileUtils.mv(rendered.path, dest)
					else
						# Requires `sudo` be properly configured
						system("sudo mv #{rendered.path} #{dest}")
					end
				end

				tpl_path = File.join(
					Config.get('template_root'),
					'pixie',
					'system.erb')
				tpl = IO.read(tpl_path)

				# For each system
				Data::System.all(:hwaddr.not => nil).each do |o|
				Template::Pixie.render_to_file(o.merged_attributes, tpl) do |rendered|
					dest = File.join(Config.get('pxe_root'), o.hwaddr.gsub(/:/, '-'))
					unless Config.get('via_sudo')
						FileUtils.mv(rendered.path, dest)
					else
						# Requires `sudo` be properly configured
						system("sudo mv #{rendered.path} #{dest}")
					end
				end
				end

			end
		end

	end
end
