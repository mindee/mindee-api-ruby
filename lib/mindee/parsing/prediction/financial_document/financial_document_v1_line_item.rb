# frozen_string_literal: true

module Mindee
  # List of line item details.
  class FinancialDocumentV1LineItem
    # The item description.
    # @return [String]
    attr_reader :description
    # The product code referring to the item.
    # @return [String]
    attr_reader :product_code
    # The item quantity
    # @return [Float]
    attr_reader :quantity
    # The item tax amount.
    # @return [Float]
    attr_reader :tax_amount
    # The item tax rate in percentage.
    # @return [Float]
    attr_reader :tax_rate
    # The item total amount.
    # @return [Float]
    attr_reader :total_amount
    # The item unit price.
    # @return [Float]
    attr_reader :unit_price
    # @return [Float]
    attr_reader :confidence
    # @return [Integer]
    attr_reader :page_id
    # @return [Mindee::Geometry::Quadrilateral]
    attr_reader :bounding_box
    # @return [Array<Mindee::Geometry::Polygon>]
    attr_reader :polygon

    def initialize(prediction, page_id)
      @description = prediction['description']
      @product_code = prediction['product_code']
      @quantity = prediction['quantity']
      @tax_amount = prediction['tax_amount']
      @tax_rate = prediction['tax_rate']
      @total_amount = prediction['total_amount']
      @unit_price = prediction['unit_price']
      @page_id = page_id
    end

    # Format strings for display by shortening long strings and assigning empty ones.
    # @param input_str [String, nil]
    # @param max_size [int]
    # @return [String]
    def format_for_display(in_str, max_size)
      return '' if in_str.nil?

      in_str.length < max_size ? in_str : "#{in_str[0..max_size - 3]}..."
    end

    # @return [Hash]
    def printable_values
      printable = {}
      printable[:description] = format_for_display(@description, 36)
      printable[:product_code] = format_for_display(@product_code, 12)
      printable[:quantity] = @quantity.nil? ? '' : Field.float_to_string(@quantity)
      printable[:tax_amount] = @tax_amount.nil? ? '' : Field.float_to_string(@tax_amount)
      printable[:tax_rate] = @tax_rate.nil? ? '' : Field.float_to_string(@tax_rate)
      printable[:total_amount] = @total_amount.nil? ? '' : Field.float_to_string(@total_amount)
      printable[:unit_price] = @unit_price.nil? ? '' : Field.float_to_string(@unit_price)
      printable
    end

    # @return [String]
    def to_table_line
      printable = printable_values
      out_str = String.new
      out_str << format('| %- 37s', printable[:description])
      out_str << format('| %- 13s', printable[:product_code])
      out_str << format('| %- 9s', printable[:quantity])
      out_str << format('| %- 11s', printable[:tax_amount])
      out_str << format('| %- 13s', printable[:tax_rate])
      out_str << format('| %- 13s', printable[:total_amount])
      out_str << format('| %- 11s', printable[:unit_price])
      out_str << '|'
    end

    # @return [String]
    def to_s
      printable = printable_values
      out_str = String.new
      out_str << printable[:description]
      out_str << printable[:product_code]
      out_str << printable[:quantity]
      out_str << printable[:tax_amount]
      out_str << printable[:tax_rate]
      out_str << printable[:total_amount]
      out_str << printable[:unit_price]
      out_str.strip
    end
  end
end
