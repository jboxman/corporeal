require 'corporeal/data'
require 'corporeal/template'

module Corporeal
	module Util

		class Pixie
			# Use sudo option?
			#
			# Need to pull the key parameters and use that to build
			# a menu for profiles && for individual systems.
			# This is going to be someplace like /var/lib/tftp/pxelinux.cfg/*
			#
			# Template base calls with subclasses for PXE && Kickstart things.

			def self.sync
				Data::Profile.all.each do |o|
					puts o.inspect
				end
			end
		end

	end
end
