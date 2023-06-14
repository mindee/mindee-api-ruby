# frozen_string_literal: true

require_relative '../common_fields/base'

module Mindee
  # Line items for invoices
  class FinancialDocumentV1LineItem
    # @return [String] The product code referring to the item.
    attr_reader :product_code
    # @return [String]
    attr_reader :description
    # @return [Float]
    attr_reader :quantity
    # @return [Float]
    attr_reader :unit_price
    # @return [Float]
    attr_reader :total_amount
    # @return [Float] The item tax rate percentage.
    attr_reader :tax_rate
    # @return [Float]
    attr_reader :tax_amount
    # @return [Float]
    attr_reader :confidence
    # @return [Integer]
    attr_reader :page_id
    # @return [Mindee::Geometry::Quadrilateral]
    attr_reader :bounding_box
    # @return [Array<Mindee::Geometry::Polygon>]
    attr_reader :polygon

    def initialize(prediction, page_id)
      @product_code = prediction['product_code']
      @quantity = prediction['quantity']
      @unit_price = prediction['unit_price']
      @total_amount = prediction['total_amount']
      @tax_amount = prediction['tax_amount']
      @tax_rate = prediction['tax_rate']
      @description = prediction['description']
      @page_id = page_id
    end

    def printable_values
      printable = {}
      printable[:description] = @description.nil? ? '' : @description
      printable[:product_code] = @product_code.nil? ? '' : @product_code
      printable[:quantity] = @quantity.nil? ? '' : Field.float_to_string(@quantity)
      printable[:tax_amount] = @tax_amount.nil? ? '' : Field.float_to_string(@tax_amount)
      printable[:tax_rate] = @tax_rate.nil? ? '' : Field.float_to_string(@tax_rate)
      printable[:total_amount] = @total_amount.nil? ? '' : Field.float_to_string(@total_amount)
      printable[:unit_price] = @unit_price.nil? ? '' : Field.float_to_string(@unit_price)
      printable
    end

    # @return String
    def to_s
      printable = printable_values
      out_str = String.new
      out_str << ("Description: #{printable[:description][0..33]}" + (printable[:description].length <= 33 ? '' : '...'))
      out_str << "Product code: #{printable[:product_code]}"
      out_str << "Quantity: #{printable[:quantity]}"
      out_str << "Tax Amount: #{printable[:tax_amount]}"
      out_str << "Tax Rate (%): #{printable[:tax_rate]}"
      out_str << "Total Amount: #{printable[:total_amount]}"
      out_str << "Unit Price: #{printable[:unit_price]}"
      out_str.strip
    end

    # @return String
    def to_table_line
      printable = printable_values
      out_str = String.new
      out_str << ("| #{printable[:description].ljust(36, ' ')}")
      out_str << (" | #{printable[:product_code].ljust(12, ' ')}")
      out_str << (" | #{printable[:quantity].ljust(8, ' ')}")
      out_str << (" | #{printable[:tax_amount].ljust(10, ' ')}")
      out_str << (" | #{printable[:tax_rate].ljust(12, ' ')}")
      out_str << (" | #{printable[:total_amount].ljust(12, ' ')}")
      out_str << (" | #{printable[:unit_price].ljust(10, ' ')} |")
      out_str.rstrip
    end
  end
end
