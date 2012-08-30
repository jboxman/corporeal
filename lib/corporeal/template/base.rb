require 'erubis'
require 'tempfile'

require 'corporeal/config'

# Provide instance method to flatten hash
Hash.send(:include, Module.new do
	def stringify
		self.inject("") do |str, kv|
			str << " " unless str.length == 0
			str << kv[0]
			str << "=#{kv[1]}" unless kv[1].nil?
			str
		end
	end
end)

module Corporeal
	module Template

		class Base
			attr_reader :vars
			attr_reader :template

			class << self
				def render(vars, template)
					t = new(vars, template)
					t.render
				end

				def render_to_file(vars, template, &blk)
					t = new(vars, template)
					t.render_to_file &blk
				end
			end

			def initialize(vars, template)
				@vars = vars
				@template = template
			end

			def to_s
				render
			end

			def render_to_string &blk
				yield render
			end

			def render_to_file &blk
				Tempfile.open("corporeal-rendered-template") do |tempfile|
					tempfile.print(render)
					tempfile.close
					yield tempfile
				end
			end

			# Need to merge in special variables
			# - proper ks= for kernel_cmdline
			# - proper value for url= in kickstart

			private

			def render
				eruby = Erubis::Eruby.new(template)
				context = context_klass.new(vars)
				eruby.evaluate(context)
			end

			# Override
			def context_klass
				Erubis::Context
			end
		end

	end
end
