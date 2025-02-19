# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module NutritionFactsLabel
      # The size of a single serving of the product.
      class NutritionFactsLabelV1ServingSize < Mindee::Parsing::Standard::FeatureField
        include Mindee::Parsing::Standard
        # The amount of a single serving.
        # @return [Float]
        attr_reader :amount
        # The unit for the amount of a single serving.
        # @return [String]
        attr_reader :unit

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @amount = prediction['amount']
          @unit = prediction['unit']
          @page_id = page_id
        end

        # @return [Hash]
        def printable_values
          printable = {}
          printable[:amount] =
            @amount.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@amount)
          printable[:unit] = format_for_display(@unit)
          printable
        end

        # @return [String]
        def to_s
          printable = printable_values
          out_str = String.new
          out_str << "\n  :Amount: #{printable[:amount]}"
          out_str << "\n  :Unit: #{printable[:unit]}"
          out_str
        end
      end
    end
  end
end
