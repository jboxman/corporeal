ENV['RACK_ENV'] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../../lib/corporeal/boot")

shared_context "data_helpers" do
	def create_distro(name)
		# Should be first_or_create(find, create)
		o = Corporeal::Data::Distro.create(
			:name => name,
			:arch => 'x86_64',
			:initrd_path => '/images/initrd.img',
			:kernel_path => '/images/linuz',
			:kernel_cmdline => {
		                        "root" => "/dev/mapper/vg-root",
		                        "ro" => nil,
		                        "LANG"=> "en_US.UTF-8"
		                       },
			:kickstart_path => '/tpl/kickstart/default.ks.erb',
			:kickstart_variables => {"key" => "val"})
		#o.valid? ? o : raise("Invalid Distro")
	end

	def create_profile(name, distro)
		o = Corporeal::Data::Profile.create(
			:name => name,
			:distro => Corporeal::Data::Distro.first(:name => distro))
		#o.valid? ? o : raise("Invalid Profile")
	end

	def create_system(name, profile, attrs={})
		o = Corporeal::Data::System.create(attrs.merge(
			:name => name,
			:profile => Corporeal::Data::Profile.first(:name => profile),
			:ip => IPAddr.new('172.16.100.1'),
			:hwaddr => 'ff:ff:ff:ff:ff:ff'))
		#o.valid? ? o : raise("Invalid System")
	end
end
