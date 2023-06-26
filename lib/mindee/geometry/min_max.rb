# frozen_string_literal: true

module Mindee
  # Various helper functions & classes for geometry.
  module Geometry
    # A set of minimum and maximum values.
    class MinMax
      # Minimum
      # @return [Float]
      attr_reader :min
      # Maximum
      # @return [Float]
      attr_reader :max

      # @param min [Float]
      # @param max [Float]
      def initialize(min, max)
        @min = min
        @max = max
      end
    end
  end
end
