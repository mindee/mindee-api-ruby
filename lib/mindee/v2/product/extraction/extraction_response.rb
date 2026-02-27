# frozen_string_literal: true

require_relative '../../../parsing/v2/inference_response'
require_relative 'extraction_inference'

module Mindee
  module V2
    module Product
      module Extraction
        # HTTP response wrapper that embeds a V2 Inference.
        class ExtractionResponse < Mindee::Parsing::V2::InferenceResponse
          # @return [ExtractionInference] Parsed inference payload.
          attr_reader :inference

          def initialize(server_response)
            super
            @inference = Mindee::V2::Product::Extraction::ExtractionInference.new(server_response['inference'])
          end
        end
      end
    end
  end
end
