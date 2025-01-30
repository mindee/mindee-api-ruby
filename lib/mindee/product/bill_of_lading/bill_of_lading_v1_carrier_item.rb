# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module BillOfLading
      # The goods being shipped.
      class BillOfLadingV1CarrierItem < Mindee::Parsing::Standard::FeatureField
        include Mindee::Parsing::Standard
        # A description of the item.
        # @return [String]
        attr_reader :description
        # The gross weight of the item.
        # @return [Float]
        attr_reader :gross_weight
        # The measurement of the item.
        # @return [Float]
        attr_reader :measurement
        # The unit of measurement for the measurement.
        # @return [String]
        attr_reader :measurement_unit
        # The quantity of the item being shipped.
        # @return [Float]
        attr_reader :quantity
        # The unit of measurement for weights.
        # @return [String]
        attr_reader :weight_unit

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @description = prediction['description']
          @gross_weight = prediction['gross_weight']
          @measurement = prediction['measurement']
          @measurement_unit = prediction['measurement_unit']
          @quantity = prediction['quantity']
          @weight_unit = prediction['weight_unit']
          @page_id = page_id
        end

        # @return [Hash]
        def printable_values
          printable = {}
          printable[:description] = format_for_display(@description)
          printable[:gross_weight] = @gross_weight.nil? ? '' : BaseField.float_to_string(@gross_weight)
          printable[:measurement] = @measurement.nil? ? '' : BaseField.float_to_string(@measurement)
          printable[:measurement_unit] = format_for_display(@measurement_unit)
          printable[:quantity] = @quantity.nil? ? '' : BaseField.float_to_string(@quantity)
          printable[:weight_unit] = format_for_display(@weight_unit)
          printable
        end

        # @return [Hash]
        def table_printable_values
          printable = {}
          printable[:description] = format_for_display(@description, 36)
          printable[:gross_weight] = @gross_weight.nil? ? '' : BaseField.float_to_string(@gross_weight)
          printable[:measurement] = @measurement.nil? ? '' : BaseField.float_to_string(@measurement)
          printable[:measurement_unit] = format_for_display(@measurement_unit, nil)
          printable[:quantity] = @quantity.nil? ? '' : BaseField.float_to_string(@quantity)
          printable[:weight_unit] = format_for_display(@weight_unit, nil)
          printable
        end

        # @return [String]
        def to_table_line
          printable = table_printable_values
          out_str = String.new
          out_str << format('| %- 37s', printable[:description])
          out_str << format('| %- 13s', printable[:gross_weight])
          out_str << format('| %- 12s', printable[:measurement])
          out_str << format('| %- 17s', printable[:measurement_unit])
          out_str << format('| %- 9s', printable[:quantity])
          out_str << format('| %- 12s', printable[:weight_unit])
          out_str << '|'
        end

        # @return [String]
        def to_s
          printable = printable_values
          out_str = String.new
          out_str << "\n  :Description: #{printable[:description]}"
          out_str << "\n  :Gross Weight: #{printable[:gross_weight]}"
          out_str << "\n  :Measurement: #{printable[:measurement]}"
          out_str << "\n  :Measurement Unit: #{printable[:measurement_unit]}"
          out_str << "\n  :Quantity: #{printable[:quantity]}"
          out_str << "\n  :Weight Unit: #{printable[:weight_unit]}"
          out_str
        end
      end
    end
  end
end
