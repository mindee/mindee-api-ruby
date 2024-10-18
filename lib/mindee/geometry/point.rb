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

      # rubocop:disable Naming/MethodParameterName

      # @param x [Float]
      # @param y [Float]
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
  end
end
