# frozen_string_literal: true

require_relative '../common_fields'
require_relative '../base'
require_relative 'receipt_v5_line_item'

module Mindee
  module Prediction
    # Expense Receipt v5 prediction results.
    class ReceiptV5 < Prediction
      # The locale identifier in BCP 47 (RFC 5646) format: ISO language code, '-', ISO country code.
      # @return [Mindee::Locale]
      attr_reader :locale
      # The receipt category among predefined classes.
      # @return [Mindee::ClassificationField]
      attr_reader :category
      # The receipt sub category among predefined classes for transport and food.
      # @return [Mindee::ClassificationField]
      attr_reader :subcategory
      # Whether the document is an expense receipt or a credit card receipt.
      # @return [Mindee::ClassificationField]
      attr_reader :document_type
      # The date the purchase was made.
      # @return [Mindee::DateField]
      attr_reader :date
      # Time of purchase with 24 hours formatting (HH:MM).
      # @return [Mindee::TextField]
      attr_reader :time
      # The total amount paid including taxes, discounts, fees, tips, and gratuity.
      # @return [Mindee::AmountField]
      attr_reader :total_amount
      # The total amount excluding taxes.
      # @return [Mindee::AmountField]
      attr_reader :total_net
      # The total amount of taxes.
      # @return [Mindee::AmountField]
      attr_reader :total_tax
      # The total amount of tip and gratuity.
      # @return [Mindee::AmountField]
      attr_reader :tip
      # List of tax lines information including: Amount, tax rate, tax base amount and tax code.
      # @return [Array<Mindee::TaxField>]
      attr_reader :taxes
      # The name of the supplier or merchant.
      # @return [Mindee::TextField]
      attr_reader :supplier_name
      # List of supplier company registrations or identifiers.
      # @return [Array<Mindee::CompanyRegistration>]
      attr_reader :supplier_company_registrations
      # The address of the supplier or merchant returned as a single string.
      # @return [Mindee::TextField]
      attr_reader :supplier_address
      # The Phone number of the supplier or merchant returned as a single string.
      # @return [Mindee::TextField]
      attr_reader :supplier_phone_number
      # Full extraction of lines, including: description, quantity, unit price and total.
      # @return [Array<Mindee::ReceiptV5LineItem>]
      attr_reader :line_items

      # @param prediction [Hash]
      # @param page_id [Integer, nil]
      def initialize(prediction, page_id)
        super
        @locale = Locale.new(prediction['locale'], page_id)
        @category = ClassificationField.new(prediction['category'], page_id)
        @subcategory = ClassificationField.new(prediction['subcategory'], page_id)
        @document_type = ClassificationField.new(prediction['document_type'], page_id)
        @date = DateField.new(prediction['date'], page_id)
        @time = TextField.new(prediction['time'], page_id)
        @total_amount = AmountField.new(prediction['total_amount'], page_id)
        @total_net = AmountField.new(prediction['total_net'], page_id)
        @total_tax = AmountField.new(prediction['total_tax'], page_id)
        @tip = AmountField.new(prediction['tip'], page_id)
        @taxes = []
        prediction['taxes'].each do |item|
          @taxes.push(TaxField.new(item, page_id))
        end
        @supplier_name = TextField.new(prediction['supplier_name'], page_id)
        @supplier_company_registrations = []
        prediction['supplier_company_registrations'].each do |item|
          @supplier_company_registrations.push(CompanyRegistration.new(item, page_id))
        end
        @supplier_address = TextField.new(prediction['supplier_address'], page_id)
        @supplier_phone_number = TextField.new(prediction['supplier_phone_number'], page_id)
        @line_items = []
        prediction['line_items'].each do |item|
          @line_items.push(ReceiptV5LineItem.new(item, page_id))
        end
      end

      # @return String
      def to_s
        taxes = @taxes.join("\n #{' ' * 7}")
        supplier_company_registrations = @supplier_company_registrations.join("\n #{' ' * 32}")
        line_items = line_items_to_s
        out_str = String.new
        out_str << "\n:Expense Locale: #{@locale}".rstrip
        out_str << "\n:Expense Category: #{@category}".rstrip
        out_str << "\n:Expense Sub Category: #{@subcategory}".rstrip
        out_str << "\n:Document Type: #{@document_type}".rstrip
        out_str << "\n:Purchase Date: #{@date}".rstrip
        out_str << "\n:Purchase Time: #{@time}".rstrip
        out_str << "\n:Total Amount: #{@total_amount}".rstrip
        out_str << "\n:Total Excluding Taxes: #{@total_net}".rstrip
        out_str << "\n:Total Tax: #{@total_tax}".rstrip
        out_str << "\n:Tip and Gratuity: #{@tip}".rstrip
        out_str << "\n:Taxes: #{taxes}".rstrip
        out_str << "\n:Supplier Name: #{@supplier_name}".rstrip
        out_str << "\n:Supplier Company Registrations: #{supplier_company_registrations}".rstrip
        out_str << "\n:Supplier Address: #{@supplier_address}".rstrip
        out_str << "\n:Supplier Phone Number: #{@supplier_phone_number}".rstrip
        out_str << "\n:Line Items:"
        out_str << line_items
        out_str[1..].to_s
      end

      private

      def line_items_separator(char)
        "  +#{char * 38}+#{char * 10}+#{char * 14}+#{char * 12}+"
      end

      def line_items_to_s
        return '' if @line_items.empty?

        line_items = @line_items.map(&:to_s).join("\n#{line_items_separator('-')}\n  ")
        out_str = String.new
        out_str << "\n#{line_items_separator('-')}"
        out_str << "\n  | Description #{' ' * 25}| Quantity | Total Amount | Unit Price |"
        out_str << "\n#{line_items_separator('=')}"
        out_str << "\n  #{line_items}"
        out_str << "\n#{line_items_separator('-')}"
      end
    end
  end
end
