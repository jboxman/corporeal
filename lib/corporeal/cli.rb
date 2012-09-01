require 'thor'
require 'thor/actions'
require 'thor/group'

module Corporeal
	class Cli < Thor
		include Thor::Actions

		def initialize(*)
			super
		end

		desc "config", "Show configuration"
		def config
			puts Config.all.to_yaml
		end
	end
end
