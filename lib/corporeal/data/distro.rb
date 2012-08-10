require 'corporeal/data/base'

module Corporeal
	module Data
		class Distro
			include Corporeal::Data::Base
			has n, :profiles

			validates_presence_of :arch
			validates_presence_of :initrd_path
			validates_presence_of :kernel_path
			validates_presence_of :kernel_cmdline
			validates_presence_of :kickstart_path
		end
	end
end
