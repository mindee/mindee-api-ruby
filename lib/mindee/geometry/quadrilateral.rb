# frozen_string_literal: true

module Mindee
  # Various helper functions & classes for geometry.
  module Geometry
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

      # A quadrilateral has four corners, always.
      def size
        4
      end

      # A quadrilateral has four corners, always.
      def count
        4
      end
    end
  end
end
