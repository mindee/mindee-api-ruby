# frozen_string_literal: true

require_relative 'extraction_response'
require_relative 'extraction_result'
require_relative 'params/extraction_parameters'

module Mindee
  module V2
    module Product
      module Extraction
        # Extraction inference.
        class ExtractionInference < Mindee::V2::Parsing::BaseInference
          # @return [InferenceActiveOptions] Options which were activated during the inference.
          attr_reader :active_options
          # @return [ExtractionResult] Result contents.
          attr_reader :result

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            super

            @active_options = V2::Parsing::InferenceActiveOptions.new(server_response['active_options'])
            @result = ExtractionResult.new(server_response['result'])
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
