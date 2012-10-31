module Corporeal
	module Template

		class Kickstart < Base

			class Context < Erubis::Context

				# Define get_* for Corporeal::Config options
				Corporeal::Config.all do |key, val|
					define_method("get_#{key}".to_sym) do
						Corporeal::Config.get(key)
					end
				end

				def url
					url = "http://"
					url << Corporeal::Config.get('http_server')
					url << "/distros/#{@distro_name}/#{@arch}"
					"url --url=#{url}"
				end

				def vars(key=false)
					key == false ? @kickstart_variables : @kickstart_variables[key]
				end
			end

			private

			def context_klass
				Context
			end
		end

	end
end
