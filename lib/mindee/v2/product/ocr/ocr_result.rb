# frozen_string_literal: true

require_relative 'ocr_page'

module Mindee
  module V2
    module Product
      module OCR
        # Result of a ocr utility inference.
        class OCRResult
          # @return [Array<OCRPage>] List of OCR results for each page in the document.
          attr_reader :pages

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            @pages = if server_response.key?('pages')
                       server_response['pages'].map do |pages|
                         OCRPage.new(pages)
                       end
                     end
          end

          # String representation.
          # @return [String]
          def to_s
            pages_str = @pages.join("\n")

            "Pages\n======\n#{pages_str}"
          end
        end
      end
    end
  end
end
