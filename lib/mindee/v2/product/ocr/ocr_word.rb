# frozen_string_literal: true

module Mindee
  module V2
    module Product
      module OCR
        # OCR result for a single word extracted from the document page.
        class OCRWord
          # @return [String] Text content of the word.
          attr_reader :content
          # @return [Mindee::Geometry::Polygon] Position information as a list of points in clockwise order.
          attr_reader :polygon

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            @content = server_response['content']
            @polygon = Mindee::Geometry::Polygon.new(server_response['polygon'])
          end

          # String representation.
          # @return [String]
          def to_s
            @content
          end
        end
      end
    end
  end
end
