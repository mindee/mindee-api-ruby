# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module NutritionFactsLabel
      # The amount of nutrients in the product.
      class NutritionFactsLabelV1Nutrient < Mindee::Parsing::Standard::FeatureField
        include Mindee::Parsing::Standard
        # DVs are the recommended amounts of nutrients to consume or not to exceed each day.
        # @return [Float]
        attr_reader :daily_value
        # The name of nutrients of the product.
        # @return [String]
        attr_reader :name
        # The amount of nutrients per 100g of the product.
        # @return [Float]
        attr_reader :per_100g
        # The amount of nutrients per serving of the product.
        # @return [Float]
        attr_reader :per_serving
        # The unit of measurement for the amount of nutrients.
        # @return [String]
        attr_reader :unit

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @daily_value = prediction['daily_value']
          @name = prediction['name']
          @per_100g = prediction['per_100g']
          @per_serving = prediction['per_serving']
          @unit = prediction['unit']
          @page_id = page_id
        end

        # @return [Hash]
        def printable_values
          printable = {}
          printable[:daily_value] =
            @daily_value.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@daily_value)
          printable[:name] = format_for_display(@name)
          printable[:per_100g] =
            @per_100g.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@per_100g)
          printable[:per_serving] =
            @per_serving.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@per_serving)
          printable[:unit] = format_for_display(@unit)
          printable
        end

        # @return [Hash]
        def table_printable_values
          printable = {}
          printable[:daily_value] =
            @daily_value.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@daily_value)
          printable[:name] = format_for_display(@name, 20)
          printable[:per_100g] =
            @per_100g.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@per_100g)
          printable[:per_serving] =
            @per_serving.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@per_serving)
          printable[:unit] = format_for_display(@unit, nil)
          printable
        end

        # @return [String]
        def to_table_line
          printable = table_printable_values
          out_str = String.new
          out_str << format('| %- 12s', printable[:daily_value])
          out_str << format('| %- 21s', printable[:name])
          out_str << format('| %- 9s', printable[:per_100g])
          out_str << format('| %- 12s', printable[:per_serving])
          out_str << format('| %- 5s', printable[:unit])
          out_str << '|'
        end

        # @return [String]
        def to_s
          printable = printable_values
          out_str = String.new
          out_str << "\n  :Daily Value: #{printable[:daily_value]}"
          out_str << "\n  :Name: #{printable[:name]}"
          out_str << "\n  :Per 100g: #{printable[:per_100g]}"
          out_str << "\n  :Per Serving: #{printable[:per_serving]}"
          out_str << "\n  :Unit: #{printable[:unit]}"
          out_str
        end
      end
    end
  end
end
