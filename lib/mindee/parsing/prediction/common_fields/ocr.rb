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

      def to_s
        @text.to_s
      end
    end

    # A list of words which are on the same line.
    class OcrLine < Array
      # @param prediction [Hash]
      # @param page_id [Integer, nil]
      def initialize(prediction)
        super(prediction.map { |word_prediction| OcrWord.new(word_prediction) })
      end

      # Sort the words on the line from left to right.
      def sort_on_x
        sort_by { |word| word.polygon.get_min_max_x.min}
      end

      def to_s
        each(&:to_s).join(' ')
      end
    end

    # OCR extraction for a single page.
    class OcrPage
      # All the words on the page, in semi-random order.
      # @param all_words [Array<OcrWord>]
      attr_reader :all_words
      # @param lines [Array<OcrLines>]
      attr_reader :lines

      def initialize(prediction)
        @lines = []
        @all_words = prediction["all_words"].each { |word_prediction| OcrWord.new(word_prediction) }
      end

      # All the words on the page, ordered in lines.
      # @return [OcrLine]
      def all_lines
        @lines = to_lines if @lines.empty?
        @lines
      end

      def to_s
        all_lines.each(&:to_s).join('\n')
      end

      private

      # Order all the words on the page into lines.
      # @param current [OcrWord, nil]
      # @param indexes [Array<Integer>]
      # @param current [Array<OcrLine>]
      def to_lines
        current = nil
        indexes = []
        lines = []

        # make sure words are sorted from top to bottom
        @all_words = all_words.sort_by { |word| word.polygon.get_max_y.min }
        @all_words.each do
          line = OcrLine.new
          @all_words.each_with_index do |word, idx|
            if idx in indexes
              next
            elsif current.nil?
              current = word
              indexes.push(idx)
              line = OcrLine.new
              line.append(word)
            else
              if words_on_same_line?(current, word)
                line.push(word)
                indexes.push(idx)
              end
            end
          end
          current = nil
          if line.any?
            line.sort_on_x
            lines.append(line)
          end
        end
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
      # List of pages.
      # @param pages [Array<OcrPage>]
      attr_reader :pages

      def initialize(prediction)
        @pages = prediction["pages"].each { |page_prediction| OcrPage.new(page_prediction) }
      end

      def to_s
        @pages.each {|page| page.to_s}.join('\n')
      end
    end

    # OCR extraction from the entire document.
    class Ocr
      # Mindee Vision v1 results.
      # @return [Mindee::Ocr::MVisionV1]
      attr_reader :mvision_v1

      def initialize(prediction)
        @mvision_v1 = MVisionV1.new(prediction["mvision-v1"])
      end

      def to_s
        @mvision_v1.to_s
      end
    end
  end
end
