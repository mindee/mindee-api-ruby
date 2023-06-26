# frozen_string_literal: true

module Mindee
  module Parsing
    module Standard
      # An element's position on the image
      class PositionField
        # @return [Mindee::Geometry::Polygon]
        attr_reader :polygon
        # @return [Mindee::Geometry::Polygon]
        attr_reader :value
        # @return [Mindee::Geometry::Quadrilateral]
        attr_reader :quadrangle
        # @return [Mindee::Geometry::Quadrilateral]
        attr_reader :rectangle
        # @return [Mindee::Geometry::Quadrilateral]
        attr_reader :bounding_box

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          @polygon = Geometry.polygon_from_prediction(prediction['polygon']) unless prediction['polygon'].empty?
          @quadrangle = to_quadrilateral(prediction, 'quadrangle')
          @rectangle = to_quadrilateral(prediction, 'rectangle')
          @bounding_box = to_quadrilateral(prediction, 'bounding_box')
          @page_id = page_id || prediction['page_id']
          @value = @polygon
        end

        # @return [String]
        def to_s
          out_str = String.new
          out_str << "Polygon with #{@polygon.size} points."
        end

        private

        def to_quadrilateral(prediction, key)
          Geometry.quadrilateral_from_prediction(prediction[key]) unless prediction[key].empty?
        end
      end
    end
  end
end
