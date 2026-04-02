# frozen_string_literal: true

require_relative 'ocr_result'

module Mindee
  module V2
    module Product
      module OCR
        # The inference result for an OCR utility request.
        class OCRInference < Mindee::V2::Parsing::BaseInference
          # @return [OCRResult] Parsed inference payload.
          attr_reader :result

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            super

            @result = OCRResult.new(server_response['result'])
          end

          # String representation.
          # @return [String]
          def to_s
            [
              super,
              @result.to_s,
              '',
            ].join("\n")
          end
        end
      end
    end
  end
end
