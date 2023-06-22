# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    # Expense Receipt V4 document prediction.
    class ReceiptV4Document < Prediction
      # Where the purchase was made, the language, and the currency.
      # @return [Mindee::Parsing::Standard::Locale]
      attr_reader :locale
      # Total including taxes
      # @return [Mindee::Parsing::Standard::AmountField]
      attr_reader :total_amount
      # Total amount of the purchase excluding taxes.
      # @return [Mindee::Parsing::Standard::AmountField]
      attr_reader :total_net
      # Total tax amount of the purchase.
      # @return [Mindee::Parsing::Standard::AmountField]
      attr_reader :total_tax
      # The purchase date.
      # @return [Mindee::Parsing::Standard::DateField]
      attr_reader :date
      # The name of the supplier or merchant, as seen on the receipt.
      # @return [Mindee::Parsing::Standard::TextField]
      attr_reader :supplier
      # List of taxes detected on the receipt.
      # @return [Mindee::Parsing::Standard::Parsing::Standard::Taxes]
      attr_reader :taxes
      # Time as seen on the receipt in HH:MM format.
      # @return [Mindee::Parsing::Standard::TextField]
      attr_reader :time
      # The receipt category among predefined classes.
      # @return [Mindee::Parsing::Standard::ClassificationField]
      attr_reader :category
      # The receipt sub-category among predefined classes.
      # @return [Mindee::Parsing::Standard::ClassificationField]
      attr_reader :subcategory
      # Whether the document is an expense receipt or a credit card receipt.
      # @return [Mindee::Parsing::Standard::ClassificationField]
      attr_reader :document_type
      # Total amount of tip and gratuity. Both typed and handwritten characters are supported.
      # @return [Mindee::Parsing::Standard::AmountField]
      attr_reader :tip

      # @param prediction [Hash]
      # @param page_id [Integer, nil]
      def initialize(prediction, page_id)
        super()
        @locale = Parsing::Standard::Locale.new(prediction['locale'])
        @total_amount = Parsing::Standard::AmountField.new(prediction['total_amount'], page_id)
        @total_net = Parsing::Standard::AmountField.new(prediction['total_net'], page_id)
        @total_tax = Parsing::Standard::AmountField.new(prediction['total_tax'], page_id)
        @tip = Parsing::Standard::AmountField.new(prediction['tip'], page_id)
        @date = Parsing::Standard::DateField.new(prediction['date'], page_id)
        @category = Parsing::Standard::ClassificationField.new(prediction['category'], page_id)
        @subcategory = Parsing::Standard::ClassificationField.new(prediction['subcategory'], page_id)
        @document_type = Parsing::Standard::ClassificationField.new(prediction['document_type'], page_id)
        @supplier = Parsing::Standard::TextField.new(prediction['supplier'], page_id)
        @time = Parsing::Standard::TextField.new(prediction['time'], page_id)
        @taxes = Parsing::Standard::Taxes.new(prediction['taxes'], page_id)
      end

      def to_s
        out_str = String.new
        out_str << "\n:Locale: #{@locale}".rstrip
        out_str << "\n:Date: #{@date}".rstrip
        out_str << "\n:Category: #{@category}".rstrip
        out_str << "\n:Subcategory: #{@subcategory}".rstrip
        out_str << "\n:Document type: #{@document_type}".rstrip
        out_str << "\n:Time: #{@time}".rstrip
        out_str << "\n:Supplier name: #{@supplier}".rstrip
        out_str << "\n:Taxes:#{@taxes}".rstrip
        out_str << "\n:Total net: #{@total_net}".rstrip
        out_str << "\n:Total tax: #{@total_tax}".rstrip
        out_str << "\n:Tip: #{@tip}".rstrip
        out_str << "\n:Total amount: #{@total_amount}".rstrip
        out_str[1..].to_s
      end
    end
  end
end
