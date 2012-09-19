require 'rubygems'

if File.exists?('corporeal.gemspec')
	lib = File.expand_path('lib', File.dirname(__FILE__))
else
	spec = Gem::Specification.find_by_name('corporeal')
	lib = File.join(spec.gem_dir, 'lib')
end

$:.unshift(lib) unless $:.include?(lib)

require 'corporeal/boot'
require 'corporeal/config'
require 'corporeal/database'
require 'corporeal/handler'

Corporeal::Database.prepare!

run Corporeal::Handler
