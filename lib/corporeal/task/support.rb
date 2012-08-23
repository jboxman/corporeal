module Corporeal
	module Task
		class Support < Thor
			class_option :abc, :type => :string
			desc "pxe", "Generate PXE boot menus"
			def pxe
				puts Data::Profile.all
				# Use sudo option?
				#
				# Need to pull the key parameters and use that to build
				# a menu for profiles && for individual systems.
				# This is going to be someplace like /var/lib/tftp/pxelinux.cfg/*
				#
				# Template base calls with subclasses for PXE && Kickstart things.
			end

			Corporeal::Cli.register(Support, 'support', 'support [COMMAND]', 'Support tasks')
		end
	end
end
