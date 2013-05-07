require 'data_mapper'

require 'corporeal/config'
require 'corporeal/data'

module Corporeal
	module Database
		extend self

		def prepare!(memory=false)
			if memory
				DataMapper::Logger.new($stdout, :info)
				DataMapper.setup(:default, 'sqlite::memory:')
			else
				db_path = Corporeal::Config.get('database')
				DataMapper.setup(:default, "sqlite://#{db_path}")
			end

			DataMapper.repository(:default).adapter.resource_naming_convention =
				DataMapper::NamingConventions::Resource::UnderscoredAndPluralizedWithoutModule
			DataMapper.finalize
			DataMapper.auto_upgrade!
			DataMapper::Model.raise_on_save_failure = false

		rescue DataObjects::ConnectionError
			raise "Invalid 'database' path: #{Corporeal::Config.get('database')}"
		end
	end
end
