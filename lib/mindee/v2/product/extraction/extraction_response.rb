# frozen_string_literal: true

require_relative 'extraction_inference'

module Mindee
  module V2
    module Product
      module Extraction
        # HTTP response wrapper that embeds a V2 Inference.
        class ExtractionResponse < Mindee::V2::Parsing::BaseResponse
          # @return [ExtractionInference] Parsed inference payload.
          attr_reader :inference

          @slug = 'extraction'
          @_params_type = Params::ExtractionParameters

          def initialize(server_response)
            super

            @inference = Mindee::V2::Product::Extraction::ExtractionInference.new(server_response['inference'])
          end

          # String representation.
          # @return [String]
          def to_s
            @inference.to_s
          end
        end
      end
    end
  end
end
