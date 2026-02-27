# frozen_string_literal: true

require_relative 'ocr_result'

module Mindee
  module V2
    module Product
      module Ocr
        # The inference result for an OCR utility request.
        class OcrInference < Mindee::V2::Parsing::BaseInference
          # @return [OcrResult] Parsed inference payload.
          attr_reader :result

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            super

            @result = OcrResult.new(server_response['result'])
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
