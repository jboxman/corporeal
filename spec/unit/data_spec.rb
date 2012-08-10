require "corporeal/data"

shared_context "setup" do |klass|
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

	def create(name)
		Corporeal::Data::Distro.create(
			:name => name,
			:arch => 'x86_64',
			:initrd_path => '/var/lib/tftp/images/initrd.img',
			:kernel_path => '/var/lib/tftp/images/linuz',
			:kernel_cmdline => 'root=/dev/mapper/vg-root ro LANG=en_US.UTF-8',
			:kickstart_path => 'tpl/ks/default.erb',
			:kickstart_variables => {"key" => "val"})
	end

	include_context "setup", Corporeal::Data::Distro
	include_examples "common"

	let(:distro) { create("somelinux") ; Corporeal::Data::Distro.first }

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
end

describe Corporeal::Data::System do

	include_context "setup", Corporeal::Data::System
	include_examples "common"
end
