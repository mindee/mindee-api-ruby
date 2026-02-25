# frozen_string_literal: true

require_relative 'ocr_word'

module Mindee
  module V2
    module Product
      module Ocr
        # OCR result for a single page.
        class OcrPage
          # @return [Array<OcrWord>] List of words extracted from the document page.
          attr_reader :words
          # @return [String] Full text content extracted from the document page.
          attr_reader :content

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            @words = server_response['words'].map { |word| OcrWord.new(word) }
            @content = server_response['content']
          end

          # String representation.
          # @return [String]
          def to_s
            ocr_words = "\n"
            ocr_words += @words.map(&:to_s).join("\n\n") if @words&.any?
            "OCR Words\n======#{ocr_words}\n\n:Content: #{@content}"
          end
        end
      end
    end
  end
end
