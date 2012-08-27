require File.join(File.dirname(__FILE__), "spec_helper")
require "corporeal/data"

shared_context "setup" do |klass|
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
			:kickstart_path => '/tpl/ks/default.erb',
			:kickstart_variables => {"key" => "val"})
		#o.valid? ? o : raise("Invalid Distro")
	end

	def create_profile(name, distro)
		o = Corporeal::Data::Profile.create(
			:name => name,
			:distro => Corporeal::Data::Distro.first(:name => distro))
		#o.valid? ? o : raise("Invalid Profile")
	end

	def create_system(name, profile)
		o = Corporeal::Data::System.create(
			:name => name,
			:profile => Corporeal::Data::Profile.first(:name => profile),
			:ip => IPAddr.new('172.16.100.1'),
			:hwaddr => 'ff:ff:ff:ff:ff:ff')
		#o.valid? ? o : raise("Invalid System")
	end

	before do
		DataMapper::Logger.new($stdout, :info)
		DataMapper.setup(:default, 'sqlite::memory:')
		DataMapper.finalize
		klass.auto_migrate!
	end
end

shared_examples "common" do
	it "should inherit Base properties" do
		ary = [
			:id,
			:name,
			:arch,
			:initrd_path,
			:kernel_path,
			:kernel_cmdline,
			:kickstart_path,
			:kickstart_variables
		]
		ary.each do |prop|
			described_class.new.respond_to?(prop).should be_true
		end
	end
end

describe Corporeal::Data::Distro do

	include_context "setup", Corporeal::Data::Distro
	include_examples "common"

	let(:distro) { create_distro("somelinux") ; Corporeal::Data::Distro.first }

	it "should require arch" do
		distro.arch = nil
		distro.save
		distro.errors[:arch].should_not be_nil
	end

	it "should require initrd_path" do
		distro.initrd_path = nil
		distro.save
		distro.errors[:initrd_path].should_not be_nil
	end

	it "should require kernel_path" do
		distro.kernel_path = nil
		distro.save
		distro.errors[:kernel_path].should_not be_nil
	end

	it "should require kickstart_path" do
		distro.kickstart_path = nil
		distro.save
		distro.errors[:kickstart_path].should_not be_nil
	end

	it "should enforce alphanumerics, dashes, and underscores in name" do
		distro.name = "gnu linux"
		distro.save
		distro.errors[:name].should_not be_nil

		distro.name = "GNU/Linux"
		distro.save
		distro.errors[:name].should_not be_nil

		distro.name = "BigLinux-x86_64"
		distro.save
		distro.errors[:name].should eq([])
	end
end

describe Corporeal::Data::Profile do

	include_context "setup", Corporeal::Data::Profile
	include_examples "common"

	before do
		create_distro("profile_linux")
	end

	let(:profile) do
		create_profile("prof", "profile_linux")
		Corporeal::Data::Profile.first
	end

	it "must belong to a Distro" do
		o = create_profile("aprof", nil)
		o.errors[:distro].should_not be_nil
	end

	it "should merge attributes with its Distro" do
		o = {
			:kernel_path => '/images/linux.img',
			:initrd_path => '/images/alternate.img'
		}

		o.each do |k, v|
			profile.update(k => v)
			profile.merged_attributes[k].should eq(v)
		end

		# Should probably be its own set of tests.
		#
		h = {"merged_key" => "merged_val"}
		h_merged = {"merged_key" => "merged_val", "key" => "val"}
		profile.update(:kickstart_variables => h)

		profile.merged_attributes[:kickstart_variables].should eq(h_merged)
	end

end

describe Corporeal::Data::System do

	include_context "setup", Corporeal::Data::System
	include_examples "common"

	before do
		create_distro("prod_distro")
		create_profile("production", "prod_distro")
	end

	let(:server) do
		create_system("server", "production")
	end

	it "must belong to a Profile" do
		o = create_system("asys", nil)
		o.errors[:profile].should_not be_nil
	end

	it "should transform hw addr to upper case" do
		hwaddr = '00:1e:FF:FF:FF:ff'
		server.update(:hwaddr => hwaddr)
		server.attributes[:hwaddr].should == hwaddr.downcase
	end

	it "should have an IP address described by IPAddr" do
		server.attributes[:ip].should be_a_kind_of(IPAddr)
	end

	it "should require an IP address" do
		server.update(:ip => 'just a string')
		server.save
		server.errors[:ip].should_not be_nil

		server.update(:ip => IPAddr.new('10.10.10.1'))
		server.save
		server.errors[:ip].should eq([])
	end

	it "should require a hardware address" do
		server.update(:hwaddr => nil)
		server.save
		server.errors[:hwaddr].should_not be_nil
	end

	it "should have a valid hardware address" do
		server.update(:hwaddr => '00___00')
		server.save
		server.errors[:hwaddr].should_not be_nil
	end

	it "should merge attributes with its profile" do
	end
end
