# frozen_string_literal: true

module Mindee
  # Various helper functions for geometry.
  module Geometry
    # Transform a prediction into a Quadrilateral.
    def self.quadrilateral_from_prediction(prediction)
      throw "Prediction must have exactly 4 points, found #{prediction.size}" if prediction.size != 4

      Quadrilateral.new(
        Point.new(prediction[0][0], prediction[0][1]),
        Point.new(prediction[1][0], prediction[1][1]),
        Point.new(prediction[2][0], prediction[2][1]),
        Point.new(prediction[3][0], prediction[3][1])
      )
    end

    # Transform a prediction into a Polygon.
    def self.polygon_from_prediction(prediction)
      polygon = Polygon.new
      return polygon if prediction.nil?

      prediction.each do |point|
        polygon << Point.new(point[0], point[1])
      end
      polygon
    end

    # @return [Array<Float>]
    def self.get_bbox(vertices)
      x_coords = vertices.map(&:x)
      y_coords = vertices.map(&:y)
      [x_coords.min, y_coords.min, x_coords.max, y_coords.max]
    end

    # @return [Mindee::Geometry::Quadrilateral]
    def self.get_bounding_box(vertices)
      x_min, y_min, x_max, y_max = get_bbox(vertices)
      Quadrilateral.new(
        Point.new(x_min, y_min),
        Point.new(x_max, y_min),
        Point.new(x_max, y_max),
        Point.new(x_min, y_max)
      )
    end

    # Get the central point (centroid) given a sequence of points.
    # @param points [Array<Mindee::Geometry::Point>]
    # @return [Mindee::Geometry::Point]
    def self.get_centroid(points)
      vertices_count = points.size
      x_sum = points.map(&:x).sum
      y_sum = points.map(&:y).sum
      Point.new(x_sum / vertices_count, y_sum / vertices_count)
    end

    # Get the maximum and minimum Y value given a sequence of points.
    # @param points [Array<Mindee::Geometry::Point>]
    # @return [Mindee::Geometry::MinMax]
    def self.get_min_max_y(points)
      coords = points.map(&:y)
      MinMax.new(coords.min, coords.max)
    end

    # Get the maximum and minimum X value given a sequence of points.
    # @param points [Array<Mindee::Geometry::Point>]
    # @return [Mindee::Geometry::MinMax]
    def self.get_min_max_x(points)
      coords = points.map(&:x)
      MinMax.new(coords.min, coords.max)
    end
  end
end
