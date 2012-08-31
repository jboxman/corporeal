module Corporeal
	module Task

		class Support < Thor
			desc "init", "Initialize"
			def init
				# Make any missing directories
				# Create database, although it happens automatically now
			end

			desc "config", "Show configuration"
			def config
				puts Config.all.to_yaml
			end

			desc "sync", "Sync configuration"
			option :pxe, :type => :boolean, :default => false
			option :dns, :type => :boolean, :default => false
			option :dhcp, :type => :boolean, :default => false
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
