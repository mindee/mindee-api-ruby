# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module Receipt
      # List of all line items on the receipt.
      class ReceiptV5LineItem < Mindee::Parsing::Standard::FeatureField
        include Mindee::Parsing::Standard
        # The item description.
        # @return [String]
        attr_reader :description
        # The item quantity.
        # @return [Float]
        attr_reader :quantity
        # The item total amount.
        # @return [Float]
        attr_reader :total_amount
        # The item unit price.
        # @return [Float]
        attr_reader :unit_price

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @description = prediction['description']
          @quantity = prediction['quantity']
          @total_amount = prediction['total_amount']
          @unit_price = prediction['unit_price']
          @page_id = page_id
        end

        # @return [Hash]
        def printable_values
          printable = {}
          printable[:description] = format_for_display(@description)
          printable[:quantity] =
            @quantity.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@quantity)
          printable[:total_amount] =
            @total_amount.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@total_amount)
          printable[:unit_price] =
            @unit_price.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@unit_price)
          printable
        end

        # @return [Hash]
        def table_printable_values
          printable = {}
          printable[:description] = format_for_display(@description, 36)
          printable[:quantity] =
            @quantity.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@quantity)
          printable[:total_amount] =
            @total_amount.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@total_amount)
          printable[:unit_price] =
            @unit_price.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@unit_price)
          printable
        end

        # @return [String]
        def to_table_line
          printable = table_printable_values
          out_str = String.new
          out_str << format('| %- 37s', printable[:description])
          out_str << format('| %- 9s', printable[:quantity])
          out_str << format('| %- 13s', printable[:total_amount])
          out_str << format('| %- 11s', printable[:unit_price])
          out_str << '|'
        end

        # @return [String]
        def to_s
          printable = printable_values
          out_str = String.new
          out_str << "\n  :Description: #{printable[:description]}"
          out_str << "\n  :Quantity: #{printable[:quantity]}"
          out_str << "\n  :Total Amount: #{printable[:total_amount]}"
          out_str << "\n  :Unit Price: #{printable[:unit_price]}"
          out_str
        end
      end
    end
  end
end
