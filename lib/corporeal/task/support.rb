require 'fileutils'

module Corporeal
	module Task

		class Support < Thor

			desc "mkdir", "Create subordinate dirs"
			def mkdir

				tftp_path = Corporeal::Config.get('tftp_path')
				tftp_dirs = ['pxelinux.cfg', 'images']

				tftp_dirs.each do |dir|
					target = File.join(tftp_path, dir)
					unless File.directory?(target)
						FileUtils.mkdir_p(target)
					end
				end

				web_path = Corporeal::Config.get('web_path')
				web_dirs = ['distros']

				web_dirs.each do |dir|
					target = File.join(web_path, dir)
					unless File.directory?(target)
						FileUtils.mkdir_p(target)
					end
				end
			end

			desc "sync", "Sync configuration"
			option :pxe, :type => :boolean, :default => false
			# TODO
			# - Incorporate
			#option :dns, :type => :boolean, :default => false
			#option :dhcp, :type => :boolean, :default => false
			option :all, :type => :boolean, :default => true
			def sync
				if options['all'] || options['pxe']
					Util::Pixie.sync
				end
			end

			Corporeal::Cli.register(Support, 'support', 'support [COMMAND]', 'Support tasks')
		end

	end
end
