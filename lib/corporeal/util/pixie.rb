require 'corporeal/config'
require 'corporeal/data'
require 'corporeal/template'

require 'fileutils'

module Corporeal
	module Util

		class Pixie
			def self.sync
				h = {}
				h['items'] = ""

				self.scrub!

				Data::Profile.all.each do |o|
					tpl_path = File.join(
						Config.get('template_path'),
						'pixie',
						'profile.erb')
					tpl = IO.read(tpl_path)
					t = Template::Pixie.new(o.merged_attributes, tpl)
					h['items'] << t.to_s
				end

				tpl_path = File.join(
					Config.get('template_path'),
					'pixie',
					'default.erb')
				tpl = IO.read(tpl_path)

				dest = self.tftp_path('default')
				self.save_template(h, tpl, dest)

				tpl_path = File.join(
					Config.get('template_path'),
					'pixie',
					'system.erb')
				tpl = IO.read(tpl_path)

				Data::System.all(
					:hwaddr.not => nil,
					:disabled.not => true).each do |o|
					dest = self.tftp_path("01-#{o.hwaddr.gsub(/:/, '-')}")
					self.save_template(o.merged_attributes, tpl, dest)
				end

			end

			private

			def self.tftp_path(file)
				File.join(
					Config.get('tftp_path'),
					'pxelinux.cfg',
					file)
			end

			def self.scrub!
				Dir["#{Config.get('tftp_path')}/pxelinux.cfg/*"].each do |file|
					f = File.basename(file)
					next unless f[0..2] == '01-' || f == 'default'
					FileUtils.rm(self.tftp_path(f))
				end
			end

			def self.save_template(vars, tpl, dest)
				Template::Pixie.render_to_file(vars, tpl) do |rendered|
					FileUtils.mv(rendered.path, dest)
					FileUtils.chmod(0644, dest)

					# Respect SELinux contexts
					if File.exists?('/usr/bin/chcon')
						system("chcon -u system_u -r object_r -t tftpdir_t #{dest}")
					end
				end
			end
		end

	end
end
