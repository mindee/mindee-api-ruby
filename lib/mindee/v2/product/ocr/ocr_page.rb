# frozen_string_literal: true

require_relative 'ocr_word'

module Mindee
  module V2
    module Product
      module OCR
        # OCR result for a single page.
        class OCRPage
          # @return [Array<OCRWord>] List of words extracted from the document page.
          attr_reader :words
          # @return [String] Full text content extracted from the document page.
          attr_reader :content

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            @words = server_response['words'].map { |word| OCRWord.new(word) }
            @content = server_response['content']
          end

          # String representation.
          # @return [String]
          def to_s
            ocr_words = "\n"
            ocr_words += @words.join("\n\n") if @words&.any?
            "OCR Words\n======#{ocr_words}\n\n:Content: #{@content}"
          end
        end
      end
    end
  end
end
