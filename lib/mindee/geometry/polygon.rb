# frozen_string_literal: true

module Mindee
  # Various helper functions & classes for geometry.
  module Geometry
    # Contains any number of vertex coordinates (Points).
    class Polygon < Array
      # Get the central point (centroid) of the polygon.
      def centroid
        Geometry.get_centroid(self)
      end

      # Determine if the Point is in the Polygon's Y-axis.
      # @param point [Mindee::Geometry::Point]
      # @return [Boolean]
      def point_in_y?(point)
        min_max = Geometry.get_min_max_y(self)
        min_max.min <= point.y && point.y <= min_max.max
      end
    end
  end
end
