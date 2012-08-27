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
					h.merge!(Corporeal::Config.get('kernel_cmdline'))
					#
					# Our initrd image
					#
					h.merge!('initrd' => @initrd_path)
					#
					# Our kickstart file
					#
					h.merge!('ks' => "http://#{Config.get('http_server')}/")
					#
					# Our unified cmdline
					#
					h.merge!(@kernel_cmdline)
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
