# frozen_string_literal: true

module Mindee
  # Various helper functions for geometry.
  module Geometry
    # @return [Array<Float>]
    def self.get_bbox(vertices)
      x_min = vertices.map { |v| v[0] }.min
      x_max = vertices.map { |v| v[0] }.max
      y_min = vertices.map { |v| v[1] }.min
      y_max = vertices.map { |v| v[1] }.max
      [x_min, y_min, x_max, y_max]
    end

    # @return [Array<Array<Float>>]
    def self.get_bounding_box(vertices)
      x_min, y_min, x_max, y_max = get_bbox(vertices)
      [[x_min, y_min], [x_max, y_min], [x_max, y_max], [x_min, y_max]]
    end
  end
end
