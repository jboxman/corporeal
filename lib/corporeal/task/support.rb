module Corporeal
	module Task

		class Support < Thor
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
