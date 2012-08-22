module Corporeal
	module Task

		class Base < Thor
			class_option :arch, :type => :string,
				:desc => 'i386 or x86_64'
			class_option :initrd_path, :type => :string,
				:desc => 'Path to initrd image'
			class_option :kernel_path, :type => :string,
				:desc => 'Path to kernel image'
			class_option :kernel_cmdline, :type => :hash,
				:desc => 'Boot parameters'
			class_option :kickstart_path, :type => :string,
				:desc => 'Path to kickstart template'

			# Must be defined inside inheriting class to be accessible
			# via #tasks class method.
			#
			def self.inherited(klass)
				klass.class_eval do
					desc "list", "List"
					def list
						list_action(options)
					end

					desc "show [NAME]", "Show"
					def show(name)
						show_action(name, options)
					end

					desc "create [NAME]", "Create"
					def create(name)
						create_action(name, options)
					end

					desc "edit [NAME]", "Edit"
					def edit(name)
						action_edit(name, options)
					end

					desc "delete [NAME]", "Delete"
					def delete(name)
						delete_action(name, options)
					end
				end
			end

			private

			def list_action(*options)
				action_klass.new(options).list
			end

			def show_action(*options)
				action_klass.new(options).show
			end

			def create_action(*options)
				action_klass.new(options).create
			end

			def edit_action(*options)
				action_klass.new(options).edit
			end

			def delete_action(*options)
				action_klass.new(options).delete
			end

		end
	end
end
