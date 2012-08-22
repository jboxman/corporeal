module Corporeal
	module Template

		class PxeLinux < Base

			class Context < Erubis::Context
				# Provide unified cmdline for kernel
				def cmdline
					h = {}
					h.merge!(Corporeal::Config.get('kernel_cmdline'))
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
