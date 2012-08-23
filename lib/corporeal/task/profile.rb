module Corporeal
	module Task
		class Profile < Base

			Corporeal::Cli.register(Profile, 'profile', 'profile [COMMAND]', 'Manage profiles')
			#Corporeal::Cli.tasks["profile"].options = class_options

			tasks["edit"].options.merge!(
				{:kickstart_variables => Thor::Option.parse(:kickstart_variables, false)})

			%w{edit create}.each do |t|
				tasks[t].options.merge!(
					{:distro_name => Thor::Option.parse(:distro_name, :required)})
			end

			private

			def action_klass
				Action::Profile
			end

		end
	end
end
