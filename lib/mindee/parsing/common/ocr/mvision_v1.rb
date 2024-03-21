# frozen_string_literal: true

module Mindee
  module Parsing
    module Common
      module Ocr
        # Mindee Vision V1.
        class MVisionV1
          # List of pages.
          # @return [Array<OcrPage>]
          attr_reader :pages

          # @param prediction [Hash]
          def initialize(prediction)
            @pages = []
            prediction['pages'].each do |page_prediction|
              @pages.push(OcrPage.new(page_prediction))
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
          # @return [Mindee::Parsing::Common::Ocr::OcrLine]
          def reconstruct_vertically(coordinates, page_id, x_margin)
            line_arr = OcrLine.new([])
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
