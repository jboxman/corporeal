require 'thor'
require 'thor/actions'
require 'thor/group'

require 'json'

require 'corporeal/config'
require 'corporeal/data'
require 'corporeal/action'
require 'corporeal/template'
require 'corporeal/util'

module Corporeal
	class Cli < Thor
		include Thor::Actions

		def initialize(*)
			super
		end
	end
end
