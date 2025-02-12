# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature 'sig/custom/net_http.rbs'
  signature 'sig/mindee/*.rbs'
  signature 'sig/mindee/http/*.rbs'
  signature 'sig/mindee/geometry/*.rbs'
  signature 'sig/mindee/errors/*.rbs'
  signature 'sig/mindee/parsing/**/*.rbs'
  signature 'sig/mindee/product/universal/*.rbs'
  signature 'sig/mindee/input/**/*.rbs'

  check 'lib/mindee/*.rb'
  check 'lib/mindee/http/*.rb'
  check 'lib/mindee/geometry/*.rb'
  check 'lib/mindee/errors/*.rb'
  check 'lib/mindee/parsing/**/*.rb'
  check 'lib/mindee/product/universal/*.rb'
  check 'lib/mindee/input/**/*.rbs'
  # check 'bin'                       # CLI files
  library 'date'
  library 'logger'
  library 'json'
  # library 'net/http' # NOTE: do NOT enable until Steep fixes their support for this library.
  # Use the stub located at sig/custom/net_http.rbs instead.
  library 'time'
  library 'uri'

  configure_code_diagnostics(D::Ruby.default) # `default` diagnostics setting (applies by default)
  # configure_code_diagnostics(D::Ruby.strict) # `strict` diagnostics setting
  # configure_code_diagnostics(D::Ruby.lenient)      # `lenient` diagnostics setting
  # configure_code_diagnostics(D::Ruby.silent)       # `silent` diagnostics setting
  # configure_code_diagnostics do |hash|             # You can set up everything yourself
  #   hash[D::Ruby::NoMethod] = :information
  # end
end

target :test do
  signature 'sig/test'
  check 'test'

  configure_code_diagnostics(D::Ruby.lenient) # Weak type checking for test code
end
