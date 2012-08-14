require 'corporeal/data/base'

module Corporeal
	module Data
		class Profile
			include Corporeal::Data::Base

			belongs_to :distro

			property :chef_attributes, Object, :default => lambda {Hash.new}

			validates_presence_of :distro

			def merged_attributes
				Chef::Mixin::DeepMerge.deep_merge(attributes, distro.attributes)
			end
		end
	end
end
