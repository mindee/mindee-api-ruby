# frozen_string_literal: true

require_relative 'extraction_response'
require_relative 'params/extraction_parameters'

module Mindee
  module V2
    module Product
      module Extraction
        # Extraction product.
        class Extraction < Mindee::V2::Parsing::BaseInference
          @params_type = Product::Extraction::Params::ExtractionParameters
          @response_type = Product::Extraction::ExtractionResponse
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
end
