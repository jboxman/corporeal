module Corporeal
	module Task
		class System < Base

			Corporeal::Cli.register(System, 'system', 'system [COMMAND]', 'Manage systems')
			#Corporeal::Cli.tasks["system"].options = class_options

			tasks["edit"].options.merge!({
				:kickstart_variables => Thor::Option.parse(:kickstart_variables, false),
				:hwaddr => Thor::Option.parse(:hwaddr, :string)
			})

			%w{create}.each do |t|
				tasks[t].options.merge!(
					{:profile_name => Thor::Option.parse(:profile_name, :required)})
			end

			private

			def action_klass
				Action::System
			end

		end
	end
end
