# frozen_string_literal: true

require_relative '../common_fields'
require_relative '../base'

module Mindee
  # Receipt document.
  class ReceiptV4 < Prediction
    # @return [Mindee::Locale]
    attr_reader :locale
    # @return [Mindee::Amount]
    attr_reader :total_amount
    # @return [Mindee::Amount]
    attr_reader :total_net
    # @return [Mindee::Amount]
    attr_reader :total_tax
    # @return [Mindee::DateField]
    attr_reader :date
    # @return [Mindee::Field]
    attr_reader :supplier
    # @return [Array<Mindee::TaxField>]
    attr_reader :taxes
    # @return [Mindee::Field]
    attr_reader :time
    # @return [Mindee::Field]
    attr_reader :category

    # @param prediction [Hash]
    # @param page_id [Integer, nil]
    def initialize(prediction, page_id)
      super
      @locale = Locale.new(prediction['locale'])
      @total_amount = Amount.new(prediction['total_amount'], page_id)
      @total_net = Amount.new(prediction['total_net'], page_id)
      @total_tax = Amount.new(prediction['total_tax'], page_id)
      @tip = Amount.new(prediction['tip'], page_id)
      @date = DateField.new(prediction['date'], page_id)
      @category = Field.new(prediction['category'], page_id)
      @supplier = Field.new(prediction['supplier'], page_id)
      @time = Field.new(prediction['time'], page_id)
      @taxes = []
      prediction['taxes'].each do |item|
        @taxes.push(TaxField.new(item, page_id))
      end
    end

    def to_s
      taxes = @taxes.join("\n       ")
      out_str = String.new
      out_str << "\n:Locale: #{@locale}".rstrip
      out_str << "\n:Date: #{@date}".rstrip
      out_str << "\n:Category: #{@category}".rstrip
      out_str << "\n:Time: #{@time}".rstrip
      out_str << "\n:Supplier name: #{@supplier}".rstrip
      out_str << "\n:Taxes: #{taxes}".rstrip
      out_str << "\n:Total net: #{@total_net}".rstrip
      out_str << "\n:Total taxes: #{@total_tax}".rstrip
      out_str << "\n:Tip: #{@tip}".rstrip
      out_str << "\n:Total amount: #{@total_amount}".rstrip
      out_str[1..].to_s
    end
  end
end
