module Corporeal
	module Template

		class Kickstart < Base

			class Context < Erubis::Context
			end

			private

			def context_klass
				Context
			end
		end

	end
end
