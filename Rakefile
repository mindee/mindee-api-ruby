# frozen_string_literal: true

require 'rake'
require 'rspec/core/rake_task'

is_lite_mode = ENV.fetch('MINDEE_GEM_NAME', 'mindee') == 'mindee-lite'

begin
  require 'bundler/setup'
  require 'bundler/gem_helper'
  Bundler::GemHelper.install_tasks(name: ENV.fetch('MINDEE_GEM_NAME', 'mindee'))
rescue LoadError
  puts 'although not required, bundler is recommended for running the tests'
end

task default: :spec
exclusion_opts = is_lite_mode ? ['--tag', '~full_deps'] : []
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = exclusion_opts
end
unless is_lite_mode
  require 'yard'
  desc 'Generate documentation'
  YARD::Rake::YardocTask.new(:doc) do |task|
    task.files = ['lib/**/*.rb']
  end

  Rake::Task[:doc].enhance do
    FileUtils.cp_r(
      File.join('docs', 'code_samples'),
      File.join('docs', '_build')
    )
  end
end

desc 'Run integration tests'
RSpec::Core::RakeTask.new(:integration) do |t|
  t.pattern = 'spec/**/*_integration.rb'
  t.rspec_opts = ['--require', 'integration_helper'] + exclusion_opts
end
