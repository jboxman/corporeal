module Corporeal
	module Task

		class Distro < Base

			Corporeal::Cli.register(Distro, 'distro', 'distro [COMMAND]', 'Manage distributions')
			#Corporeal::Cli.tasks["distro"].options = class_options

			desc "import [NAME]", "Import"
			def import
			# rsync import distribution
			# Create definition.
			# It'll go in a directory named by NAME
			# Need to use Config class to figure out where this will happen
			# The kernel && initrd names for RHEL are already known
			# Also need to include a couple additional kernel cmd options
			end

			tasks["edit"].options.merge!(
				{:kickstart_variables => Thor::Option.parse(:kickstart_variables, false)})

			private

			def action_klass
				Action::Distro
			end
		end

	end
end
