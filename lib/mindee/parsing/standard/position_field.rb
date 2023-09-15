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
          unless prediction['polygon'].nil? || prediction['polygon'].empty?
            @polygon = Geometry.polygon_from_prediction(prediction['polygon'])
          end
          @quadrangle = to_quadrilateral(prediction, 'quadrangle')
          @rectangle = to_quadrilateral(prediction, 'rectangle')
          @bounding_box = to_quadrilateral(prediction, 'bounding_box')
          @page_id = page_id || prediction['page_id']
          @value = @polygon
        end

        # rubocop:disable Metrics/CyclomaticComplexity
        # rubocop:disable Metrics/PerceivedComplexity
        # @return [String]
        def to_s
          return "Polygon with #{@polygon.size} points." if @polygon&.size&.positive?
          return "Polygon with #{@bounding_box.size} points." if @bounding_box&.size&.positive?
          return "Polygon with #{@rectangle.size} points." if @rectangle&.size&.positive?
          return "Polygon with #{@quadrangle.size} points." if @quadrangle&.size&.positive?

          ''
        end
        # rubocop:enable Metrics/CyclomaticComplexity
        # rubocop:enable Metrics/PerceivedComplexity

        private

        def to_quadrilateral(prediction, key)
          Geometry.quadrilateral_from_prediction(prediction[key]) unless prediction[key].nil? || prediction[key].empty?
        end
      end
    end
  end
end
