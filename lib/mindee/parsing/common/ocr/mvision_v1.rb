# frozen_string_literal: true

module Mindee
  module Parsing
    module Common
      module OCR
        # Mindee Vision V1.
        class MVisionV1
          # List of pages.
          # @return [Array<OCRPage>]
          attr_reader :pages

          # @param prediction [Hash]
          def initialize(prediction)
            @pages = [] # : Array[Mindee::Parsing::Common::OCR::OCRPage]
            prediction['pages'].each do |page_prediction|
              @pages.push(OCRPage.new(page_prediction))
            end
          end

          # @return [String]
          def to_s
            out_str = String.new
            @pages.map do |page|
              out_str << "\n"
              out_str << page.to_s
            end
            out_str.strip
          end

          # Constructs a line from a column, located underneath given coordinates
          # @param coordinates [Array<Mindee::Geometry::Point>] Polygon or bounding box where the reconstruction should
          # start.
          # @param page_id [Integer] ID of the page to start at
          # @param x_margin [Float] Margin of misalignment for the x coordinate.
          # @return [Mindee::Parsing::Common::OCR::OCRLine]
          def reconstruct_vertically(coordinates, page_id, x_margin)
            line_arr = OCRLine.new([])
            @pages[page_id].all_lines.each do |line|
              line.each do |word|
                line_arr.push(word) if Geometry.below?(word.polygon, coordinates, x_margin / 2, x_margin * 2)
              end
            end
            line_arr
          end
        end
      end
    end
  end
end
