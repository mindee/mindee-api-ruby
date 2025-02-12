# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature 'sig/custom/net_http.rbs'
  signature 'sig/mindee/*.rbs'
  signature 'sig/mindee/http/*.rbs'
  signature 'sig/mindee/geometry/*.rbs'
  signature 'sig/mindee/errors/*.rbs'
  # signature 'sig/mindee/extraction/*.rbs' # depends on the image module
  # signature 'sig/mindee/image/**/*.rbs' # mini_magick isn't typed.
  signature 'sig/mindee/logging/**/*.rbs'
  signature 'sig/mindee/parsing/**/*.rbs'
  # signature 'sig/mindee/pdf/**/*.rbs' # Origami isn't typed.
  signature 'sig/mindee/product/universal/*.rbs'
  signature 'sig/mindee/input/**/*.rbs'

  check 'lib/mindee/*.rb'
  check 'lib/mindee/http/*.rb'
  check 'lib/mindee/geometry/*.rb'
  check 'lib/mindee/errors/*.rb'
  # check 'lib/mindee/extraction/*.rb' # depends on the image module
  # check 'lib/mindee/image/**/*.rb' # mini_magick isn't typed
  check 'lib/mindee/logging/**/*.rb'
  check 'lib/mindee/parsing/**/*.rb'
  # check 'lib/mindee/pdf/**/*.rb' # Origami isn't typed
  check 'lib/mindee/product/universal/*.rb'
  check 'lib/mindee/input/**/*.rbs'
  # check 'bin' # CLI files are ignored
  library 'date'
  library 'logger'
  library 'json'
  # library 'net/http' # NOTE: Steep does not support net/http. Do NOT enable.
  # Use the stub located at sig/custom/net_http.rbs instead.
  library 'time'
  library 'uri'

  configure_code_diagnostics(D::Ruby.default) # `default` diagnostics setting (applies by default)
end

