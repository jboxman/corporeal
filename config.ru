require 'rubygems'

if File.exists?('corporeal.gemspec')
	lib = File.expand_path('lib', File.dirname(__FILE__))
end

$:.unshift(lib) unless $:.include?(lib)

require 'corporeal/boot'
require 'corporeal/config'
require 'corporeal/database'
require 'corporeal/handler'

Corporeal::Database.prepare!

run Corporeal::Handler
