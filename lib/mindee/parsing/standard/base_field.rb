# frozen_string_literal: true

require_relative '../../geometry'

module Mindee
  module Parsing
    module Standard
      # Base Field object, upon which fields and feature fields are built
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
          @polygon = Geometry.polygon_from_prediction(prediction['polygon']) if prediction.key?('polygon')
          @bounding_box = Geometry.get_bounding_box(@polygon) unless @polygon.nil? || @polygon.empty?
          @page_id = page_id || prediction['page_id']
        end

        # @return [String]
        def to_s
          @value ? @value.to_s : ''
        end

        # Multiply all the Mindee::Parsing::Standard::Field confidences in the array.
        # @return [Float]
        def self.array_confidence(field_array)
          product = 1
          field_array.each do |field|
            return 0.0 if field.confidence.nil?

            product *= field.confidence
          end
          product.to_f
        end

        # Add all the Mindee::Parsing::Standard::Field values in the array.
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

      # Base field object.
      class Field < AbstractField
        # @return [String, Float, Integer, Boolean]
        attr_reader :value
        # true if the field was reconstructed or computed using other fields.
        # @return [Boolean]
        attr_reader :reconstructed

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        # @param reconstructed [Boolean]
        def initialize(prediction, page_id, reconstructed: false)
          super(prediction, page_id)
          @value = prediction['value']
          @reconstructed = reconstructed
        end
      end

      # Feature field object wrapper for specialized methods.
      class FeatureField < AbstractField
        # Format strings for display by shortening long strings and assigning empty ones.
        # @param in_str [String, nil]
        # @param max_col_size [int, nil]
        # @return [String]
        def format_for_display(in_str, max_col_size = nil)
          return '' if in_str.nil?
          return in_str if max_col_size.nil?

          in_str.length < max_col_size ? in_str : "#{in_str[0..max_col_size - 4]}..."
        end
      end
    end
  end
end
