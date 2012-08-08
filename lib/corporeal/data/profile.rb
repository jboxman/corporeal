require 'corporeal/data/base'

module Corporeal
	module Data
		class Profile
			include Corporeal::Data::Base

			belongs_to :distro

			property :chef_attributes, Object, :default => lambda {Hash.new}
		end
	end
end
