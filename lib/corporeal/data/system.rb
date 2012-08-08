require 'corporeal/data/base'

module Corporeal
	module Data
		class System
			include Corporeal::Data::Base

			belongs_to :profile

			# System Attributes
			property :hwaddr, String
			property :ip, String
			property :chef_attributes, Object, :default => lambda {Hash.new}
		end
	end
end
