require 'thor'
require 'thor/actions'
require 'thor/group'

require 'json'

require 'corporeal/config'
require 'corporeal/data'
require 'corporeal/action'
require 'corporeal/template'

module Corporeal
	class Cli < Thor
		include Thor::Actions

		def initialize(*)
			super

			#DataMapper::Logger.new($stdout, :debug)
			#DataMapper.setup(:default, 'sqlite::memory:')
			db_path = Corporeal::Config.get('database')
			DataMapper.setup(:default, "sqlite://#{db_path}")
			DataMapper.repository(:default).adapter.resource_naming_convention =
				DataMapper::NamingConventions::Resource::UnderscoredAndPluralizedWithoutModule
			DataMapper.finalize
			DataMapper.auto_upgrade!
			DataMapper::Model.raise_on_save_failure = false
		end
	end
end
