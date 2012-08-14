require 'corporeal/data/base'

require 'ipaddr'

module Corporeal
	module Data
		class System
			include Corporeal::Data::Base

			belongs_to :profile

			HWADDR_REGEXP = Regexp.new(/[0-9A-Za-z]{2,2}:
			                           [0-9A-Za-z]{2,2}:
			                          [0-9A-Za-z]{2,2}:
			                          [0-9A-Za-z]{2,2}:
			                          [0-9A-Za-z]{2,2}:
			                          [0-9A-Za-z]{2,2}/x)

			validates_presence_of :profile
			validates_presence_of :hwaddr, :if => lambda {|o| !o.hwaddr.nil? && o.hwaddr.length == 17}
			validates_format_of :hwaddr, :with => HWADDR_REGEXP
			validates_presence_of :ip, :if => lambda {|o| !o.ip.nil? && o.ip.is_a?(IPAddr)}

			# System Attributes
			property :hwaddr, String
			property :ip, Object
			property :chef_attributes, Object, :default => lambda {Hash.new}

			def hwaddr=(value)
				super(value.nil? ? nil : value.upcase)
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

			def merged_attributes
				Chef::Mixin::DeepMerge.deep_merge(
					attributes, distro.merged_attributes)
			end
		end
	end
end
