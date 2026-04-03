# frozen_string_literal: true

require_relative 'lib/mindee/version'

Gem::Specification.new do |spec|
  spec.name = 'mindee-lite'
  spec.version = Mindee::VERSION
  spec.authors = ['Mindee, SA']
  spec.email = ['opensource@mindee.co']

  spec.summary = 'Mindee API Helper Library for Ruby (Lite)'
  spec.description = "Quickly and easily connect to Mindee's API services using Ruby. This lite version omits " \
                     'heavy image and PDF processing dependencies.'
  spec.homepage = 'https://github.com/mindee/mindee-api-ruby'
  spec.license = 'MIT'

  spec.metadata['homepage_uri'] = 'https://mindee.com/'
  spec.metadata['source_code_uri'] = 'https://github.com/mindee/mindee-api-ruby'
  spec.metadata['changelog_uri'] = 'https://github.com/mindee/mindee-api-ruby/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(.github|spec|features)/}) }
  end
  spec.bindir = 'bin'
  spec.executables = Dir.children('bin')
                        .select { |f| File.file?(File.join('bin', f)) }
                        .reject { |f| f == 'products.rb' }
  spec.require_paths = ['lib']

  spec.required_ruby_version = Gem::Requirement.new('>= 3.2')

  spec.add_dependency 'base64', '~> 0.3'
  spec.add_dependency 'marcel', '~> 1.1'
end
