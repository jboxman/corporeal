require 'corporeal/data/base'

module Corporeal
	module Data
		class Profile
			include Corporeal::Data::Base

			belongs_to :distro

			property :chef_attributes, Object, :default => lambda {Hash.new}

			validates_presence_of :distro

			def distro_name=(value)
				self.distro = Data::Distro.first(:name => value)
			end

			def distro_name
				self.distro.name
			end

			def variables
				attributes.merge(:klass => klass_name, :distro_name => distro_name)
			end

			def merged_attributes
				DeepMerge.deep_merge!(
					variables,
					distro.attributes)
			end
		end
	end
end
