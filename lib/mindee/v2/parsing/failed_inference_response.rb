# frozen_string_literal: true

module Mindee
  module V2
    module Parsing
      # "Webhook payload returned when an inference fails before producing a result.
      class FailedInferenceResponse < Mindee::V2::Parsing::CommonResponse
        # @return [String] UUID of the failed inference.
        attr_reader :inference_id
        # @return [String] UUID of the model used.
        attr_reader :model_id
        # @return [String] Name of the input file.
        attr_reader :file_name
        # @return [String, Nil] Alias sent for the file, if any.
        attr_reader :file_alias
        # @return [Mindee::V2::Parsing::ErrorResponse] Problem details for the failure, if available.
        attr_reader :error
        # @return [Time] Date and time when the inference was started.
        attr_reader :created_at

        def initialize(server_response)
          super

          @inference_id = server_response['inference_id']
          @model_id = server_response['model_id']
          @file_name = server_response['file_name']
          @file_alias = server_response['file_alias']
          @error = ErrorResponse.new(server_response['error'])
          @created_at = Time.iso8601(server_response['created_at'])
        end
      end
    end
  end
end
