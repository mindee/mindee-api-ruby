# frozen_string_literal: true

require_relative 'lib/mindee/version'

Gem::Specification.new do |spec|
  spec.name          = 'mindee'
  spec.version       = Mindee::VERSION
  spec.authors       = ['Mindee, SA']
  spec.email         = ['devrel@mindee.co']

  spec.summary       = 'Mindee API Helper Library for Ruby'
  spec.description   = "Quickly and easily connect to Mindee's API services using Ruby."
  spec.homepage      = 'https://github.com/mindee/mindee-api-ruby'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = 'https://mindee.com/'
  spec.metadata['source_code_uri'] = 'https://github.com/mindee/mindee-api-ruby'
  spec.metadata['changelog_uri'] = 'https://github.com/mindee/mindee-api-ruby/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(.github|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = Gem::Requirement.new('>= 2.6')

  spec.add_runtime_dependency 'marcel', '~> 1.0.2'
  spec.add_runtime_dependency 'mrz', '~> 0.2'
  spec.add_runtime_dependency 'origamindee', '~> 3.0'

  spec.add_development_dependency 'rake', '~> 12.3.1'
  spec.add_development_dependency 'rspec', '~> 3.11'
  spec.add_development_dependency 'rubocop', '~> 1.41'
  spec.add_development_dependency 'yard', '0.9.28'
end
