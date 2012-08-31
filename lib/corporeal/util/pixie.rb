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

				dest = File.join(Config.get('pxe_root'), 'pxelinux.cfg', 'default')
				self.save_template(h, tpl, dest)

				tpl_path = File.join(
					Config.get('template_root'),
					'pixie',
					'system.erb')
				tpl = IO.read(tpl_path)

				# For each system
				Data::System.all(:hwaddr.not => nil).each do |o|
					dest = File.join(
						Config.get('pxe_root'),
						'pxelinux.cfg',
						o.hwaddr.gsub(/:/, '-'))
					self.save_template(o.merged_attributes, tpl, dest)
				end

			end

			private

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
