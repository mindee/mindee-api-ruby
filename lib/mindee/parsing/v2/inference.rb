# frozen_string_literal: true

require_relative 'inference_job'
require_relative 'inference_model'
require_relative 'inference_file'
require_relative 'inference_result'
require_relative 'inference_active_options'
require_relative '../../v2/parsing/base_inference'

module Mindee
  module Parsing
    module V2
      # Complete data returned by an inference request.
      class Inference < Mindee::V2::Parsing::BaseInference
        # @return [InferenceActiveOptions] Options which were activated during the inference.
        attr_reader :active_options
        # @return [InferenceResult] Result contents.
        attr_reader :result

        @params_type = Input::InferenceParameters
        @slug = 'extraction'
        @response_type = InferenceResponse

        # @param server_response [Hash] Hash representation of the JSON returned by the service.
        def initialize(server_response)
          super
          @active_options = InferenceActiveOptions.new(server_response['active_options'])
          @result = InferenceResult.new(server_response['result'])
        end

        # String representation.
        # @return [String]
        def to_s
          [
            super,
            @active_options.to_s,
            @result.to_s,
            '',
          ].join("\n")
        end
      end
    end
  end
end
