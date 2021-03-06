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
					# Our kickstart URL
					#
					path = "http://"
					path << Config.get('http_server')
					path << "/kick/#{@klass}/#{@id}"
					h.merge!('ks' => path)

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
