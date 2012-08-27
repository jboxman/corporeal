require 'data_mapper'

DataMapper::Property::String.length(255)

module Corporeal
	module Data
		module Base
			def self.included(klass)
				klass.class_eval do
					include DataMapper::Resource

					property :id,
							DataMapper::Property::Serial
					property :name,
							DataMapper::Property::String,
							:required => true
					property :arch,
							DataMapper::Property::Enum[:i386, :x86_64]
					property :initrd_path,
							DataMapper::Property::Text
					property :kernel_path,
							DataMapper::Property::Text
					property :kernel_cmdline,
							DataMapper::Property::Object,
							:default => lambda {Hash.new}
					property :kickstart_path,
							DataMapper::Property::String
					property :kickstart_variables,
							DataMapper::Property::Object,
							:default => lambda {Hash.new}

					validates_format_of :name, :with => /^[A-Za-z0-9_-]+$/
					validates_uniqueness_of :name

					validates_format_of :kernel_path,
							:with => /^\/.+/,
							:unless => lambda {|o| o.kernel_path.nil?}
					validates_format_of :initrd_path,
							:with => /^\/.+/,
							:unless => lambda {|o| o.initrd_path.nil?}
					validates_format_of :kickstart_path,
							:with => /^\/.+/,
							:unless => lambda {|o| o.kickstart_path.nil?}
				end
			end

			# Override
			def merged_attributes
			end
		end
	end
end
