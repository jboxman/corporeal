require 'fileutils'

module Corporeal
	module Task

		class Distro < Base

			Corporeal::Cli.register(Distro, 'distro', 'distro [COMMAND]', 'Manage distributions')
			#Corporeal::Cli.tasks["distro"].options = class_options

			desc "import [NAME]", "Import"
			option :path, :type => :string
			option :arch, :type => :string
			def import(name)

				path = options[:path] || false
				arch = options[:arch]

				if Data::Distro.first(:name => name)
					abort "Distro '#{name}' exists!"
				end

				if path
					verify_path(path)
					mirror_files(name, path)
					copy_images(name, path)
				elsif !arch
					abort "Must specify --arch if --path not specified"
				elsif !['i386', 'x86_64'].include?(arch)
					abort "Must specify either i386 or x86_64 for --arch"
				end

				attrs = {}
				attrs[:kernel_path] = "/images/#{name}/vmlinuz"
				attrs[:initrd_path] = "/images/#{name}/initrd.img"
				attrs[:kickstart_path] = "/kickstart/default.ks.erb"
				attrs[:arch] = path ? lookup_arch(path) : arch

				puts attrs.merge(:name => name).to_yaml
				#Distro.create attrs.merge(:name => name)
			end

			tasks["edit"].options.merge!(
				{:kickstart_variables => Thor::Option.parse(:kickstart_variables, false)})

			private

			def lookup_arch(path)
				infofile = File.join(path, '.discinfo')
				arch = File.open(infofile).readlines[2].chomp
				unless ['i386', 'x86_64'].include?(arch)
					abort "Unable to parse '#{infofile}'"
				end
				arch
			end

			def verify_path(path)
				unless File.exists?(File.join(options[:path], '.discinfo'))
					abort "Invalid path: '#{options[:path]}'"
				end
			end

			def mirror_files(name, path)
				source = path.dup
				dest = File.join(
					Config.get('web_path'),
					'distros',
					name)

				unless File.exists?(dest)
					FileUtils.mkdir_p(dest)
				end

				source << "/" unless path[-1..source.length] == "/"

				cmd = ["rsync"]
				cmd << "-aHP --stats --delete-before"
				# Verbose
				cmd << "-v"
				# Dry
				cmd << "-n"
				cmd << "--exclude-from"
				cmd << File.join(Config.config_path, 'rsync.exclude')
				cmd << "#{source}"
				cmd << "#{dest}/"

				say "Running: #{cmd.join(' ')}"
				#unless system(cmd.join(' '))
				#	abort "Non-zero exit status for rsync"
				#end
			end

			def copy_images(name, path)
				# Copy vmlinuz && initrd.img into TFTP /images/ directory
			end

			def action_klass
				Action::Distro
			end
		end

	end
end
