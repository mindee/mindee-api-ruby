# frozen_string_literal: true

require_relative 'lib/mindee/version'

Gem::Specification.new do |spec|
  spec.name          = 'mindee'
  spec.version       = Mindee::VERSION
  spec.authors       = ['Mindee, SA']
  spec.email         = ['opensource@mindee.co']

  spec.summary       = 'Mindee API Helper Library for Ruby'
  spec.description   = "Quickly and easily connect to Mindee's API services using Ruby."
  spec.homepage      = 'https://github.com/mindee/mindee-api-ruby'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri']      = 'https://mindee.com/'
  spec.metadata['source_code_uri']   = 'https://github.com/mindee/mindee-api-ruby'
  spec.metadata['changelog_uri']     = 'https://github.com/mindee/mindee-api-ruby/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(.github|spec|features)/}) }
  end
  spec.bindir = 'bin'
  spec.executables = Dir['bin/*'].map { |f| File.basename(f) }.reject { |f| f == 'cli_products.rb' }
  spec.require_paths = ['lib']

  spec.required_ruby_version = Gem::Requirement.new('>= 3.0')

  spec.add_dependency 'base64', '~> 0.1'
  spec.add_dependency 'marcel', '~> 1.0'
  spec.add_dependency 'mini_magick', '>= 4', '< 6'
  spec.add_dependency 'origamindee', '~> 4.0'
  spec.add_dependency 'pdf-reader', '~> 2.14'

  spec.add_development_dependency 'prism', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 13.2'
  spec.add_development_dependency 'rbs', '~> 3.6'
  spec.add_development_dependency 'rspec', '~> 3.13'
  spec.add_development_dependency 'rubocop', '~> 1.76'
  spec.add_development_dependency 'steep', '~> 1.7'
  spec.add_development_dependency 'yard', '~> 0.9'
end
