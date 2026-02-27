# frozen_string_literal: true

require_relative '../../../parsing/v2/inference'
require_relative 'extraction_result'

module Mindee
  module V2
    module Product
      module Extraction
        # Extraction inference.
        class ExtractionInference < Mindee::Parsing::V2::Inference
          # @return [ExtractionResult] Parsed inference payload.
          attr_reader :result

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            super

            @result = Mindee::V2::Product::Extraction::ExtractionResult.new(server_response['result'])
          end
        end
      end
    end
  end
end
