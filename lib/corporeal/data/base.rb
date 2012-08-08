require 'rubygems'
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
							DataMapper::Property::String, :required => true
					property :arch,
							DataMapper::Property::Enum[:i386, :x86_64]
					property :initrd_path,
							DataMapper::Property::Text
					property :kernel_path,
							DataMapper::Property::Text
					property :kernel_cmdline,
							DataMapper::Property::Text
					property :kickstart_path,
							DataMapper::Property::String
					property :kickstart_variables,
							DataMapper::Property::Object,
							:default => lambda {Hash.new}
				end
			end
		end
	end
end
