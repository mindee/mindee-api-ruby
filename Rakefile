# frozen_string_literal: true

require 'rake'
require 'rspec/core/rake_task'
require 'yard'

begin
  require 'bundler/setup'
  Bundler::GemHelper.install_tasks
rescue LoadError
  puts 'although not required, bundler is recommended for running the tests'
end

task default: :spec

RSpec::Core::RakeTask.new(:spec)

desc 'Generate documentation'
YARD::Rake::YardocTask.new(:doc) do |task|
  task.files = ['lib/**/*.rb']
end
