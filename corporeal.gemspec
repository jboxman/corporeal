# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
#require "shadow_path/version"

Gem::Specification.new do |s|
  s.name        = "corporeal"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jason Boxman"]
  s.email       = ["jasonb@edseek.com"]
  s.homepage    = ""
  s.summary     = %q{Corporeal}
  s.description = %q{Corporeal}

  s.rubyforge_project = ""

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "thor", "~> 0.15"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "fakefs"

  s.add_dependency "mixlib-shellout", ">= 1.0.0.rc.1"
  s.add_dependency "chef", "~> 10.12"
end
