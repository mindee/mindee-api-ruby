# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature 'sig/mindee/client.rbs'
  signature 'sig/mindee/logging/logger.rbs'
  signature 'sig/mindee.rbs'
  signature 'sig/mindee/parsing/common/inference.rbs'
  signature 'sig/mindee/input/sources/base64_input_source.rbs'
  signature 'sig/mindee/input/sources/bytes_input_source.rbs'
  signature 'sig/mindee/input/sources/file_input_source.rbs'
  signature 'sig/mindee/input/sources/local_input_source.rbs'
  signature 'sig/mindee/input/sources/path_input_source.rbs'
  signature 'sig/mindee/input/sources/url_input_source.rbs'

  check 'lib/mindee/client.rb'
  check 'lib/mindee/logging/logger.rb'
  check 'lib/mindee.rb'
  check 'lib/mindee/parsing/common/inference.rb'
  check 'lib/mindee/input/sources/base64_input_source.rbs'
  check 'lib/mindee/input/sources/bytes_input_source.rbs'
  check 'lib/mindee/input/sources/file_input_source.rbs'
  check 'lib/mindee/input/sources/local_input_source.rbs'
  check 'lib/mindee/input/sources/path_input_source.rbs'
  check 'lib/mindee/input/sources/url_input_source.rbs'
  # check 'bin'                       # CLI files
  # library "pathname"              # Standard libraries
  # library "strong_json"           # Gems
  library 'date' # add standard libraries here
  library 'logger' # add standard libraries here

  configure_code_diagnostics(D::Ruby.default) # `default` diagnostics setting (applies by default)
  # configure_code_diagnostics(D::Ruby.strict) # `strict` diagnostics setting
  # configure_code_diagnostics(D::Ruby.lenient)      # `lenient` diagnostics setting
  # configure_code_diagnostics(D::Ruby.silent)       # `silent` diagnostics setting
  # configure_code_diagnostics do |hash|             # You can set up everything yourself
  #   hash[D::Ruby::NoMethod] = :information
  # end
end

target :test do
  unreferenced!                     # Skip type checking the `lib` code when types in `test` target is changed
  signature 'sig/test'              # Put RBS files for tests under `sig/test`
  check 'test'                      # Type check Ruby scripts under `test`

  configure_code_diagnostics(D::Ruby.lenient) # Weak type checking for test code

  # library "pathname"              # Standard libraries
end
