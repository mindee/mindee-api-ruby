# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature 'sig/custom/*.rbs'
  signature 'sig/mindee/*.rbs'
  signature 'sig/mindee/http/*.rbs'
  signature 'sig/mindee/geometry/*.rbs'
  signature 'sig/mindee/errors/*.rbs'
  signature 'sig/mindee/extraction/*.rbs'
  signature 'sig/mindee/image/**/*.rbs'
  signature 'sig/mindee/logging/**/*.rbs'
  signature 'sig/mindee/parsing/**/*.rbs'
  signature 'sig/mindee/pdf/**/*.rbs'
  signature 'sig/mindee/product/**/*.rbs'
  signature 'sig/mindee/input/**/*.rbs'

  check 'lib/mindee/*.rb'
  check 'lib/mindee/http/*.rb'
  check 'lib/mindee/geometry/*.rb'
  check 'lib/mindee/errors/*.rb'
  check 'lib/mindee/extraction/*.rb'
  check 'lib/mindee/image/**/*.rb'
  check 'lib/mindee/logging/**/*.rb'
  check 'lib/mindee/parsing/**/*.rb'
  check 'lib/mindee/pdf/**/*.rb'
  check 'lib/mindee/product/**/*.rb'
  check 'lib/mindee/input/**/*.rbs'
  # check 'bin' # CLI files are ignored
  library 'date'
  library 'logger'
  library 'json'
  # library 'net/http' # NOTE: Steep does not support net/http. Do NOT enable.
  # Use the stub located at sig/custom/net_http.rbs instead.
  library 'pathname'
  library 'time'
  library 'uri'

  configure_code_diagnostics(D::Ruby.default) # `default` diagnostics setting (applies by default)
end

