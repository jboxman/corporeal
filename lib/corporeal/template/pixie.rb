module Corporeal
	module Template

		class Pixie < Base

			class Context < Erubis::Context
				#
				# Provide unified cmdline for kernel
				#
				def cmdline
					h = {}
					#
					# Any global options
					#
					h.merge!(DeepMerge.deep_merge!(@kernel_cmdline, Corporeal::Config.get('kernel_cmdline')))
					#
					# Our initrd image
					#
					h.merge!('initrd' => @initrd_path)
					#
					# Our kickstart file
					#
					h.merge!('ks' => "http://#{Config.get('http_server')}/")

					h.stringify
				end
			end

			private

			def context_klass
				Context
			end
		end

	end
end
