# frozen_string_literal: true

require_relative '../common_fields/base'

module Mindee
  # Line items for invoices
  class InvoiceLineItem
    attr_reader :product_code, :description, :quantity, :unit_price, :total_amount, :tax_rate, :tax_amount,
                :confidence, :page_id
    # @return [Array<Array<Float>>]
    attr_reader :bounding_box
    # @return [Array<Array<Float>>]
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

    def to_s
      tax = Field.float_to_string(@tax_amount)
      tax << " (#{Field.float_to_string(@tax_rate)}%)" unless @tax_rate.nil?

      description = @description.nil? ? '' : @description
      description = "#{description[0..32]}..." if description.size > 35

      out_str = String.new
      out_str << format('%- 22s', @product_code)
      out_str << " #{format('%- 8s', Field.float_to_string(@quantity))}"
      out_str << " #{format('%- 9s', Field.float_to_string(@unit_price))}"
      out_str << " #{format('%- 10s', Field.float_to_string(@total_amount))}"
      out_str << " #{format('%- 18s', tax)}"
      out_str << " #{description}"
    end
  end
end
