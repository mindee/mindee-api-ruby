# frozen_string_literal: true

module Mindee
  # Various helper functions for geometry.
  module Geometry
    # A relative set of coordinates (X, Y) on the document.
    class Point
      # @return [Float]
      attr_accessor :x
      # @return [Float]
      attr_accessor :y

      # @param x [Float]
      # @param y [Float]
      # rubocop:disable Naming/MethodParameterName
      def initialize(x, y)
        @x = x
        @y = y
      end
      # rubocop:enable Naming/MethodParameterName

      # @return [Float]
      def [](key)
        case key
        when 0
          @x
        when 1
          @y
        else
          throw '0 or 1 only'
        end
      end
    end

    # Contains exactly 4 relative vertices coordinates (Points).
    class Quadrilateral
      # @return [Mindee::Geometry::Point]
      attr_accessor :top_left
      # @return [Mindee::Geometry::Point]
      attr_accessor :top_right
      # @return [Mindee::Geometry::Point]
      attr_accessor :bottom_right
      # @return [Mindee::Geometry::Point]
      attr_accessor :bottom_left

      # @param top_left [Mindee::Geometry::Point]
      # @param top_right [Mindee::Geometry::Point]
      # @param bottom_right [Mindee::Geometry::Point]
      # @param bottom_left [Mindee::Geometry::Point]
      def initialize(top_left, top_right, bottom_right, bottom_left)
        @top_left = top_left
        @top_right = top_right
        @bottom_right = bottom_right
        @bottom_left = bottom_left
      end

      # @return [Mindee::Geometry::Point]
      def [](key)
        case key
        when 0
          @top_left
        when 1
          @top_right
        when 2
          @bottom_right
        when 3
          @bottom_left
        else
          throw '0, 1, 2, 3 only'
        end
      end
    end

    class Polygon < Array
    end

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
  end
end
