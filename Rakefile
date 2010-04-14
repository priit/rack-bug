require "rubygems"
require "spec/rake/spectask"

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ["--color"]
end

Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_opts = ["--color"]
  t.rcov = true
  t.rcov_opts = ["-x","gems,spec"]
end

task :default => :spec