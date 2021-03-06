require File.join(File.dirname(__FILE__), "spec_helper")

require "corporeal/template/base"
require "corporeal/template/pixie"
require "corporeal/template/kickstart"

describe Corporeal::Template::Base do
	let(:tpl) do
		"text <%= @ivar %>"
	end

	it "should render a template" do
		template = described_class.new({:ivar => "value"}, tpl)
		template.to_s.should == "text value"
	end

	it "should render to a block" do
		template = described_class.new({:ivar => "value"}, tpl)
		template.render_to_string do |result|
			result.should == "text value"
		end
	end
end

describe Corporeal::Template::Pixie do
	let(:tpl) do
		"text <%= cmdline %>"
	end

	let(:vars) do
		{
			:kernel_cmdline => {
		                        "root" => "/dev/mapper/vg-root",
		                        "ro" => nil,
		                        "LANG"=> "en_US.UTF-8"
		                       }
		}
	end
	let(:template) { Corporeal::Template::Pixie.new(vars, tpl) }

	it "should have a cmdline helper method" do
		puts template.to_s
	end

end

describe Corporeal::Template::Kickstart do
	let(:tpl) do
		"text "
	end

	let(:vars) do
		{:kickstart_variables => {}}
	end

	let(:template) { Corporeal::Template::Kickstart.new(vars, tpl) }
end
