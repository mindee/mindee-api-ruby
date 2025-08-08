# frozen_string_literal: true

require_relative 'mvision_v1'

module Mindee
  module Parsing
    module Common
      # Ocr-specific parsing fields and options
      module OCR
        # A single word.
        class OCRWord
          # The confidence score, value will be between 0.0 and 1.0
          # @return [Float]
          attr_reader :confidence
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

          # @return [String]
          def to_s
            @text.to_s
          end
        end

        # A list of words which are on the same line.
        class OCRLine < Array
          # @param prediction [Hash, nil]
          # @param from_array [Array<OCRWord, nil]
          def initialize(prediction = nil, from_array = nil)
            if !prediction.nil?
              super(prediction.map { |word_prediction| OCRWord.new(word_prediction) })
            elsif !from_array.nil?
              super(from_array)
            end
          end

          # Sort the words on the line from left to right.
          # @return [OCRLine]
          def sort_on_x
            from_array = sort_by { |word| Geometry.get_min_max_x(word.polygon).min }
            OCRLine.new(nil, from_array)
          end

          # @return [String]
          def to_s
            each(&:to_s).join(' ')
          end
        end

        # OCR extraction for a single page.
        class OCRPage
          # All the words on the page, in semi-random order.
          # @return [Array<OCRWord>]
          attr_reader :all_words
          # @return [Array<OCRLine>]
          attr_reader :lines

          # @param prediction [Hash]
          def initialize(prediction)
            @lines = [] # : Array[Mindee::Parsing::Common::OCR::OCRLine]
            @all_words = [] # : Array[Mindee::Parsing::Common::OCR::OCRWord]
            prediction['all_words'].each do |word_prediction|
              @all_words.push(OCRWord.new(word_prediction))
            end
          end

          # All the words on the page, ordered in lines.
          # @return [Array<OCRLine>]
          def all_lines
            @lines = to_lines if @lines.empty?
            @lines
          end

          # @return [String]
          def to_s
            lines = all_lines
            return '' if lines.empty?

            out_str = String.new
            lines.map do |line|
              out_str << "#{line}\n" unless line.to_s.strip.empty?
            end
            out_str.strip
          end

          private

          # Helper function that iterates through all the words and compares them to a candidate
          # @param sorted_words [Array<OCRWord>]
          # @param current [OCRWord]
          # @param indexes [Array<Integer>]
          # @param lines [Array<OCRLine>]
          def parse_one(sorted_words, current, indexes, lines)
            line = OCRLine.new(nil, [])
            sorted_words.each_with_index do |word, idx|
              next if indexes.include?(idx)

              if current.nil?
                current = word
                indexes.push(idx)
                line = OCRLine.new([])
                line.push(word)
              elsif words_on_same_line?(current, word)
                line.push(word)
                indexes.push(idx)
              end
            end
            lines.push(line.sort_on_x) if line.any?
          end

          # Order all the words on the page into lines.
          # @return [Array<OCRLine>]
          def to_lines
            current = nil
            indexes = [] # : Array[Integer]
            lines = [] # : Array[Mindee::Parsing::Common::OCR::OCRLine]

            # make sure words are sorted from top to bottom
            all_words = @all_words.sort_by { |word| Geometry.get_min_max_y(word.polygon).min }
            all_words.each do
              parse_one(all_words, current, indexes, lines)
              current = nil
            end
            lines
          end

          # Determine if two words are on the same line.
          # @param current_word [Mindee::Parsing::Common::OCR::OCRWord]
          # @param next_word [Mindee::Parsing::Common::OCR::OCRWord]
          # @return [bool]
          def words_on_same_line?(current_word, next_word)
            current_in_next = current_word.polygon.point_in_y?(next_word.polygon.centroid)
            next_in_current = next_word.polygon.point_in_y?(current_word.polygon.centroid) unless current_word.nil?
            current_in_next || next_in_current
          end
        end

        # OCR extraction from the entire document.
        class OCR
          # Mindee Vision v1 results.
          # @return [Mindee::Parsing::Common::OCR::MVisionV1]
          attr_reader :mvision_v1

          # @param prediction [Hash]
          def initialize(prediction)
            @mvision_v1 = Mindee::Parsing::Common::OCR::MVisionV1.new(prediction['mvision-v1'])
          end

          # @return [String]
          def to_s
            @mvision_v1.to_s
          end

          # Constructs a line from a column, located underneath given coordinates
          # @param coordinates [Array<Mindee::Geometry::Point>] Polygon or bounding box where the reconstruction should
          # start
          # @param page_id [Integer] ID of the page to start at
          # @param x_margin [Float] Margin of misalignment for the x coordinate (default 10%)
          # @return [Mindee::Parsing::Common::OCR::OCRLine]
          def reconstruct_vertically(coordinates, page_id, x_margin = 0.05)
            @mvision_v1.reconstruct_vertically(coordinates, page_id, x_margin)
          end
        end
      end
    end
  end
end
