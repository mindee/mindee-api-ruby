# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature 'sig/custom/*.rbs'
  signature 'sig/mindee/**/*.rbs'

  check 'lib/mindee/**/*.rb'
  # check 'bin' # CLI files are ignored
  library 'date'
  library 'logger'
  library 'json'
  # library 'net/http' # NOTE: Steep does not support net/http. Do NOT enable.
  # Use the stub located at sig/custom/net_http.rbs instead.
  library 'openssl'
  library 'pathname'
  library 'tempfile'
  library 'time'
  library 'uri'

  configure_code_diagnostics(D::Ruby.default) # `default` diagnostics setting (applies by default)
end

