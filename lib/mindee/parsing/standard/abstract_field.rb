# frozen_string_literal: true

require_relative '../../geometry'

module Mindee
  module Parsing
    module Standard
      # Base BaseField object, upon which fields and feature fields are built
      class AbstractField
        # @return [Mindee::Geometry::Quadrilateral, nil]
        attr_reader :bounding_box
        # @return [Mindee::Geometry::Polygon, nil]
        attr_reader :polygon
        # @return [Integer, nil]
        attr_reader :page_id
        # The confidence score, value will be between 0.0 and 1.0
        # @return [Float, nil]
        attr_accessor :confidence

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          @confidence = prediction['confidence'] if prediction.key?('confidence')
          @polygon = Mindee::Geometry::Polygon.new(prediction['polygon']) if prediction.key?('polygon')
          @bounding_box = Geometry.get_bounding_box(@polygon) unless @polygon.nil? || @polygon.empty?
          @page_id = page_id || prediction['page_id']
        end

        # @return [String]
        def to_s
          @value ? @value.to_s : ''
        end

        # Multiply all the Mindee::Parsing::Standard::BaseField confidences in the array.
        # @return [Float]
        def self.array_confidence(field_array)
          product = 1
          field_array.each do |field|
            return 0.0 if field.confidence.nil?

            product *= field.confidence
          end
          product.to_f
        end

        # Add all the Mindee::Parsing::Standard::BaseField values in the array.
        # @return [Float]
        def self.array_sum(field_array)
          arr_sum = 0
          field_array.each do |field|
            return 0.0 if field.value.nil?

            arr_sum += field.value
          end
          arr_sum.to_f
        end

        # @param value [Float]
        # @param min_precision [Integer]
        # @return [String]
        def self.float_to_string(value, min_precision = 2)
          return String.new if value.nil?

          precision = value.to_f.to_s.split('.')[1].size
          precision = [precision, min_precision].max
          format_string = "%.#{precision}f"
          format(format_string, value)
        end
      end
    end
  end
end
