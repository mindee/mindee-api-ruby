# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature 'sig/custom/net_http.rbs'
  signature 'sig/mindee/client.rbs'
  signature 'sig/mindee/logging/logger.rbs'
  signature 'sig/mindee.rbs'
  signature 'sig/mindee/version.rbs'
  signature 'sig/mindee/geometry/*.rbs'
  signature 'sig/mindee/http/endpoint.rbs'
  signature 'sig/mindee/http/http_error_handler.rbs'
  signature 'sig/mindee/http/response_validation.rbs'
  signature 'sig/mindee/http/workflow_endpoint.rbs'
  signature 'sig/mindee/errors/mindee_error.rbs'
  signature 'sig/mindee/errors/mindee_http_error.rbs'
  signature 'sig/mindee/errors/mindee_input_error.rbs'
  signature 'sig/mindee/parsing/common/api_request.rbs'
  signature 'sig/mindee/parsing/common/api_response.rbs'
  signature 'sig/mindee/parsing/common/document.rbs'
  signature 'sig/mindee/parsing/common/execution.rbs'
  signature 'sig/mindee/parsing/common/execution_file.rbs'
  signature 'sig/mindee/parsing/common/execution_priority.rbs'
  signature 'sig/mindee/parsing/common/extras/cropper_extra.rbs'
  signature 'sig/mindee/parsing/common/extras/extras.rbs'
  signature 'sig/mindee/parsing/common/extras/full_text_ocr_extra.rbs'
  signature 'sig/mindee/parsing/common/inference.rbs'
  signature 'sig/mindee/parsing/common/job.rbs'
  signature 'sig/mindee/parsing/common/ocr/*.rbs'
  signature 'sig/mindee/parsing/common/orientation.rbs'
  signature 'sig/mindee/parsing/common/page.rbs'
  signature 'sig/mindee/parsing/common/prediction.rbs'
  signature 'sig/mindee/parsing/common/product.rbs'
  signature 'sig/mindee/parsing/common/workflow_response.rbs'
  signature 'sig/mindee/parsing/standard/abstract_field.rbs'
  signature 'sig/mindee/parsing/standard/base_field.rbs'
  signature 'sig/mindee/parsing/standard/orientation_field.rbs'
  signature 'sig/mindee/parsing/standard/position_field.rbs'
  signature 'sig/mindee/parsing/standard/string_field.rbs'
  signature 'sig/mindee/parsing/universal/universal_list_field.rbs'
  signature 'sig/mindee/parsing/universal/universal_object_field.rbs'
  signature 'sig/mindee/product/universal/*.rbs'
  signature 'sig/mindee/input/sources/base64_input_source.rbs'
  signature 'sig/mindee/input/sources/bytes_input_source.rbs'
  signature 'sig/mindee/input/sources/file_input_source.rbs'
  signature 'sig/mindee/input/sources/local_input_source.rbs'
  signature 'sig/mindee/input/sources/path_input_source.rbs'
  signature 'sig/mindee/input/sources/url_input_source.rbs'

  check 'lib/mindee/client.rb'
  check 'lib/mindee/logging/logger.rb'
  check 'lib/mindee.rb'
  check 'lib/mindee/version.rb'
  check 'lib/mindee/http/endpoint.rb'
  check 'lib/mindee/geometry/*.rb'
  check 'lib/mindee/http/http_error_handler.rb'
  check 'lib/mindee/http/response_validation.rb'
  check 'lib/mindee/http/workflow_endpoint.rb'
  check 'lib/mindee/errors/mindee_error.rb'
  check 'lib/mindee/errors/mindee_http_error.rb'
  check 'lib/mindee/errors/mindee_input_error.rb'
  check 'lib/mindee/parsing/common/api_request.rb'
  check 'lib/mindee/parsing/common/api_response.rb'
  check 'lib/mindee/parsing/common/document.rb'
  check 'lib/mindee/parsing/common/execution.rb'
  check 'lib/mindee/parsing/common/execution_file.rb'
  check 'lib/mindee/parsing/common/execution_priority.rb'
  check 'lib/mindee/parsing/common/extras/cropper_extra.rb'
  check 'lib/mindee/parsing/common/extras/extras.rb'
  check 'lib/mindee/parsing/common/extras/full_text_ocr_extra.rb'
  check 'lib/mindee/parsing/common/inference.rb'
  check 'lib/mindee/parsing/common/job.rb'
  check 'lib/mindee/parsing/common/ocr/*.rb'
  check 'lib/mindee/parsing/common/orientation.rb'
  check 'lib/mindee/parsing/common/page.rb'
  check 'lib/mindee/parsing/common/prediction.rb'
  check 'lib/mindee/parsing/common/workflow_response.rb'
  check 'lib/mindee/parsing/standard/abstract_field.rb'
  check 'lib/mindee/parsing/standard/base_field.rb'
  check 'lib/mindee/parsing/standard/orientation_field.rb'
  check 'lib/mindee/parsing/standard/position_field.rb'
  check 'lib/mindee/parsing/standard/string_field.rb'
  check 'lib/mindee/parsing/universal/universal_list_field.rb'
  check 'lib/mindee/parsing/universal/universal_object_field.rb'
  check 'lib/mindee/product/universal/*.rb'
  check 'lib/mindee/input/sources/base64_input_source.rbs'
  check 'lib/mindee/input/sources/bytes_input_source.rbs'
  check 'lib/mindee/input/sources/file_input_source.rbs'
  check 'lib/mindee/input/sources/local_input_source.rbs'
  check 'lib/mindee/input/sources/path_input_source.rbs'
  check 'lib/mindee/input/sources/url_input_source.rbs'
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
  unreferenced! # Skip type checking the `lib` code when types in `test` target is changed
  signature 'sig/test'
  check 'test'

  configure_code_diagnostics(D::Ruby.lenient) # Weak type checking for test code
end
