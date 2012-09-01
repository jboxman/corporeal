require 'yaml'

module Corporeal
	class Config
		class << self
			def root
				File.expand_path(File.join(File.dirname(__FILE__), '../..'))
			end

			def config_path
				paths = [
					'/etc/corporeal/config.yml',
					File.join(root, 'config', 'config.yml')
				]
				paths.select {|path| File.exists?(path)}.first || ""
			end

			def all
				unless @config
					load_defaults
					load_overrides
				end
				@config.dup
			end

			def default(key)
				unless @defaults
					load_defaults
				end
				@defaults[key]
			end

			def set(key, value)
				@overrides ||= {}
				@overrides[key.to_s] = value
			end

			def get(key)
				unless @config
					load_defaults
					load_overrides
				end
				@config[key]
			end

			private

			def load_defaults
				@defaults = {}

				# Configure some default paths relative to root
				@defaults['template_root'] =
						File.join(self.root, 'tpl')
				@defaults['web_root'] =
						File.join(self.root, 'web')
				@defaults['pxe_root'] =
						File.join(self.root, 'tftp')

				# Configure the sqlite database path
				@defaults['database'] =
						File.join(self.root, 'db', 'corporeal.db')

				# Should be specified in the configuration file
				@defaults['http_server'] = %x[hostname -f].chomp

				# Specify some defaults for the PXE boot append option
				@defaults['kernel_cmdline'] = {
					"ksdevice" => "bootif",
					"lang" => "en.US",
					"kssendmac" => nil,
					"text" => nil
				}
			end

			def load_overrides
				unless @overrides
					begin
						@overrides = YAML.load_file(config_path)
					rescue Errno::ENOENT
						raise StandardError, "Config file not found!"
					end
				end
				@config = DeepMerge.deep_merge!(
					@overrides, @defaults)
			end

		end
	end
end
