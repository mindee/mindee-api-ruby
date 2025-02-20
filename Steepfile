# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature 'sig/custom/*.rbs'
  signature 'sig/mindee/**/*.rbs'

  check 'lib/mindee/**/*.rb'
  # check 'bin' # CLI files are ignored

  # NOTE: Steep does not support some libraries:
  # - net/http.
  # - marcel
  # - mini_magick
  # - origami (my bad)
  # Do NOT enable them.
  # Use the stubs located at sig/custom/<library_name>.rbs instead.
  library 'date'
  library 'fileutils'
  library 'logger'
  library 'json'
  library 'openssl'
  library 'pathname'
  library 'tempfile'
  library 'time'
  library 'uri'

  configure_code_diagnostics(D::Ruby.default) # `default` diagnostics setting (applies by default)
end

