# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module NutritionFactsLabel
      # The total amount of fat in the product.
      class NutritionFactsLabelV1TotalFat < Mindee::Parsing::Standard::FeatureField
        include Mindee::Parsing::Standard
        # DVs are the recommended amounts of total fat to consume or not to exceed each day.
        # @return [Float]
        attr_reader :daily_value
        # The amount of total fat per 100g of the product.
        # @return [Float]
        attr_reader :per_100g
        # The amount of total fat per serving of the product.
        # @return [Float]
        attr_reader :per_serving

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @daily_value = prediction['daily_value']
          @per_100g = prediction['per_100g']
          @per_serving = prediction['per_serving']
          @page_id = page_id
        end

        # @return [Hash]
        def printable_values
          printable = {}
          printable[:daily_value] = @daily_value.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@daily_value)
          printable[:per_100g] = @per_100g.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@per_100g)
          printable[:per_serving] = @per_serving.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@per_serving)
          printable
        end

        # @return [String]
        def to_s
          printable = printable_values
          out_str = String.new
          out_str << "\n  :Daily Value: #{printable[:daily_value]}"
          out_str << "\n  :Per 100g: #{printable[:per_100g]}"
          out_str << "\n  :Per Serving: #{printable[:per_serving]}"
          out_str
        end
      end
    end
  end
end
