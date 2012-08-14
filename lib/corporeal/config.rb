require 'yaml'
require 'chef/mixin/deep_merge'

module Corporeal
	class Config
		class << self
			def root
				File.expand_path(File.join(File.dirname(__FILE__), '../..'))
			end

			def config_path
				File.join(root, 'config.yml')
			end

			def load_defaults
				@defaults = {}

				@defaults['template_root'] =
						File.join(self.root, 'tpl')
				@defaults['web_root'] =
						File.join(self.root, 'web')
				@defaults['pxe_root'] =
						File.join(self.root, 'tftp')
				@defaults['database'] =
						File.join(self.root, 'db', 'corporeal.db')
			end

			def load_overrides
				unless @overrides
					@overrides = YAML.load_file(config_path)
					@config = Chef::Mixin::DeepMerge.deep_merge(
						@overrides, @defaults)
				end
			end

			def get(key)
				load_defaults
				load_overrides
				@config[key]
			end
		end
	end
end
