# frozen_string_literal: true

require_relative '../../parsing/base_response'
require_relative 'params/ocr_parameters'
require_relative 'ocr_inference'

module Mindee
  module V2
    module Product
      module OCR
        # HTTP response wrapper that embeds a V2 Inference.
        class OCRResponse < Mindee::V2::Parsing::BaseResponse
          # @return [OCRInference] Parsed inference payload.
          attr_reader :inference

          # @param server_response [Hash] Hash parsed from the API JSON response.
          def initialize(server_response)
            super

            @inference = OCRInference.new(server_response['inference'])
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
