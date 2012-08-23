module Corporeal
	module Action

		class Base
			attr_accessor :name
			private :name

			attr_accessor :options
			private :options

			def initialize(options)
				@name = options.first.is_a?(String) ? options.shift : nil
				@options = options.last
			end

			def list
				data_klass.all.each do |o|
					puts "#{o.name}"
				end
			end

			# Need merged option, too!
			def show
				o = data_klass.first(:name => name)
				if o
					require 'pp'
					pp o.attributes
				end
			end

			def create
				o = data_klass.new options.merge(:name => name)
				if o.save
					puts "Created"
				else
					puts o.errors.full_messages
				end
			end

			def delete
				o = data_klass.first(:name => name)
				if o && o.destroy
					puts "Deleted #{name}"
				else
					puts "#{name} not found!"
				end
			end

			def edit
				attributes = options.dup
				want_editor = attributes.delete('kickstart_variables')

				o = data_klass.first(:name => name)

				if o
					o.attributes = attributes
					success = o.save

					puts "Updated" if success

					if want_editor
						unmodified_data = o.kickstart_variables
						ok = false
						begin
							edited_data = ::JSON.parse(editor(o.kickstart_variables))
							ok = true
						rescue JSON::ParserError
							puts 'JSON ParserError, not updating!'
						end

						unless !ok || edited_data == unmodified_data
							o.update(:kickstart_variables => edited_data)
						end
					end
				else
					puts "#{name} not found!"
				end
			end

			private

			# Override
			def data_klass
			end

			def editor(obj)
				data = tempfile_for(::JSON.pretty_generate(obj)) do |filename|
					system("#{ENV['EDITOR'] || "vi"} #{filename}")
				end
			end

			# From chef/knife/core/node_editor.rb
			def tempfile_for(data)
				basename = "corporeal-" << rand(1_000_000_000_000_000).to_s.rjust(15, '0') << '.js'
				filename = File.join(Dir.tmpdir, basename)
				File.open(filename, "w+") do |f|
					f.sync = true
					f.puts data
				end

				yield filename

				IO.read(filename)
			ensure
				File.unlink(filename)
			end
		end

	end
end
