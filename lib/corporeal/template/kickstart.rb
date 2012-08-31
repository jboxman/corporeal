module Corporeal
	module Template

		class Kickstart < Base

			class Context < Erubis::Context
				def url
					url = "http://"
					url << Corporeal::Config.get('http_server')
					url << "/mirror/#{@distro_name}"
					"url --url=#{url}"
				end
			end

			private

			def context_klass
				Context
			end
		end

	end
end
