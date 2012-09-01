require 'bundler'
Bundler::GemHelper.install_tasks

require 'fileutils'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

  task :default => [:spec]
rescue LoadError
end

desc "Generate an archive of corporeal-#{Corporeal::VERSION}"
task :tarball do
	pkg = "corporeal-#{Corporeal::VERSION}"
	tar = "#{pkg}.tar"
	cmd = [
		"git archive",
		"--format=tar",
		"--prefix=#{pkg}/ HEAD",
		"> #{tar}"]
	FileUtils.rm(tar) if File.exists?(tar)
	system(cmd.join(' '))
end

desc "Generate an archive of gem dependencies for #{Corporeal::VERSION}"
task :gems do
	pkg = "corporeal-gems-#{Corporeal::VERSION}"
	tar = "#{pkg}.tar"
	system("bundle package")
	system("tar -cf #{tar} vendor/")
end
