require 'corporeal/data/base'

module Corporeal
	module Data
		class Distro
			include Corporeal::Data::Base
			has n, :profiles
		end
	end
end
