require "fileutils"

require "corporeal/config"

describe Corporeal::Config do

	let(:pwd) { Pathname("/tmp") }
	let(:config_path) {pwd.join('config.yml')}

	it "should have default values" do
		described_class.get('template_root').should_not be_nil
	end
end
