require 'corporeal/data/base'

require 'ipaddr'

module Corporeal
	module Data
		class System
			include Corporeal::Data::Base

			belongs_to :profile

			HWADDR_REGEXP = Regexp.new(/[0-9A-Za-z]{2,2}:?
			                           [0-9A-Za-z]{2,2}:?
			                          [0-9A-Za-z]{2,2}:?
			                          [0-9A-Za-z]{2,2}:?
			                          [0-9A-Za-z]{2,2}:?
			                          [0-9A-Za-z]{2,2}/x)

			validates_presence_of :profile
			validates_format_of :hwaddr, :with => HWADDR_REGEXP,
					:if => lambda {|t| !t.hwaddr.nil?}
			validates_uniqueness_of :hwaddr

			# System Attributes
			property :hwaddr, String
			property :ip, Object
			property :disabled, Boolean, :default => false
			property :chef_attributes, Object, :default => lambda {Hash.new}

			def hwaddr=(value)
				super(value.nil? ? nil : value.downcase)
			end

			def ip=(value)
				super(case value
				when String then
				     begin
						IPAddr.new(value)
				     rescue ArgumentError
						nil
				     end
				when IPAddr then value
				else
					nil
				end)
			end

			def profile_name=(value)
				self.profile = Data::Profile.first(:name => value)
			end

			def profile_name
				self.profile.name
			end

			def merged_attributes
				DeepMerge.deep_merge!(
					variables,
					profile.merged_attributes)
			end
		end
	end
end
