# frozen_string_literal: true

require_relative '../../parsing/base_response'
require_relative 'params/ocr_parameters'
require_relative 'ocr_inference'

module Mindee
  module V2
    module Product
      module Ocr
        # HTTP response wrapper that embeds a V2 Inference.
        class OcrResponse < Mindee::V2::Parsing::BaseResponse
          # @return [OcrInference] Parsed inference payload.
          attr_reader :inference

          # @param server_response [Hash] Hash parsed from the API JSON response.
          def initialize(server_response)
            super

            @inference = OcrInference.new(server_response['inference'])
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
