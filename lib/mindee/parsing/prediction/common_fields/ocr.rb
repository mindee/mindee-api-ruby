# frozen_string_literal: true

module Mindee
  module Ocr
    # A single word.
    class OcrWord
      # The confidence score, value will be between 0.0 and 1.0
      # @return [Float]
      attr_accessor :confidence
      # @return [String]
      attr_reader :text
      # @return [Mindee::Geometry::Quadrilateral]
      attr_reader :bounding_box
      # @return [Mindee::Geometry::Polygon]
      attr_reader :polygon

      # @param prediction [Hash]
      def initialize(prediction)
        @text = prediction['text']
        @confidence = prediction['confidence']
        @polygon = Geometry.polygon_from_prediction(prediction['polygon'])
        @bounding_box = Geometry.get_bounding_box(@polygon) unless @polygon.nil? || @polygon.empty?
      end
    end

    # OCR extraction for a single page.
    class OcrPage
      # All the words on the page, in semi-random order.
      attr_reader :all_words

      def initialize
        @lines = []
      end

      # All the words on the page, ordered in lines.
      def all_lines
        @lines = to_lines if @lines.empty?
        @lines
      end

      private

      # Order all the words on the page into lines.
      def to_lines
        current = nil
        indexes = []
        lines = []
      end

      # Determine if two words are on the same line.
      # @param current_word [Mindee::Ocr::OcrWord]
      # @param next_word [Mindee::Ocr::OcrWord]
      # @return Boolean
      def words_on_same_line?(current_word, next_word)
        current_in_next = current_word.polygon.point_in_y?(next_word.polygon.centroid)
        next_in_current = next_word.polygon.point_in_y?(current_word.polygon.centroid)
        current_in_next || next_in_current
      end
    end

    # Mindee Vision V1.
    class MVisionV1
      # OCR extraction for a single page.
      attr_reader :pages
    end

    # OCR extraction from the entire document.
    class Ocr
      # Mindee Vision v1 results.
      # @return [Mindee::Ocr::MVisionV1]
      attr_reader :mvision_v1
    end
  end
end
