# frozen_string_literal: true

module Mindee
  # Full extraction of lines, including: description, quantity, unit price and total.
  class ReceiptV5LineItem
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

    def initialize(prediction, page_id)
      @description = prediction['description']
      @quantity = prediction['quantity']
      @total_amount = prediction['total_amount']
      @unit_price = prediction['unit_price']
      @page_id = page_id
    end

    # @return String
    def to_s
      out_str = String.new
      out_str << format('| %- 37s', @description)
      out_str << format('| %- 9s', Field.float_to_string(@quantity))
      out_str << format('| %- 13s', Field.float_to_string(@total_amount))
      out_str << format('| %- 11s', Field.float_to_string(@unit_price))
      out_str << '|'
    end
  end
end
