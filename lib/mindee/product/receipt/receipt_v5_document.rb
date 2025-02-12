# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'receipt_v5_line_item'

module Mindee
  module Product
    module Receipt
      # Receipt API version 5.3 document data.
      class ReceiptV5Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # The purchase category among predefined classes.
        # @return [Mindee::Parsing::Standard::ClassificationField]
        attr_reader :category
        # The date the purchase was made.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :date
        # One of: 'CREDIT CARD RECEIPT', 'EXPENSE RECEIPT'.
        # @return [Mindee::Parsing::Standard::ClassificationField]
        attr_reader :document_type
        # List of line item details.
        # @return [Array<Mindee::Product::Receipt::ReceiptV5LineItem>]
        attr_reader :line_items
        # The locale detected on the document.
        # @return [Mindee::Parsing::Standard::LocaleField]
        attr_reader :locale
        # The receipt number or identifier.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :receipt_number
        # The purchase subcategory among predefined classes for transport and food.
        # @return [Mindee::Parsing::Standard::ClassificationField]
        attr_reader :subcategory
        # The address of the supplier or merchant.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :supplier_address
        # List of company registrations associated to the supplier.
        # @return [Array<Mindee::Parsing::Standard::CompanyRegistrationField>]
        attr_reader :supplier_company_registrations
        # The name of the supplier or merchant.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :supplier_name
        # The phone number of the supplier or merchant.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :supplier_phone_number
        # List of tax lines information.
        # @return [Mindee::Parsing::Standard::Taxes]
        attr_reader :taxes
        # The time the purchase was made.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :time
        # The total amount of tip and gratuity.
        # @return [Mindee::Parsing::Standard::AmountField]
        attr_reader :tip
        # The total amount paid: includes taxes, discounts, fees, tips, and gratuity.
        # @return [Mindee::Parsing::Standard::AmountField]
        attr_reader :total_amount
        # The net amount paid: does not include taxes, fees, and discounts.
        # @return [Mindee::Parsing::Standard::AmountField]
        attr_reader :total_net
        # The total amount of taxes.
        # @return [Mindee::Parsing::Standard::AmountField]
        attr_reader :total_tax

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super(prediction)
          @category = ClassificationField.new(prediction['category'], page_id)
          @date = DateField.new(prediction['date'], page_id)
          @document_type = ClassificationField.new(prediction['document_type'], page_id)
          @line_items = []
          prediction['line_items'].each do |item|
            @line_items.push(Receipt::ReceiptV5LineItem.new(item, page_id))
          end
          @locale = LocaleField.new(prediction['locale'], page_id)
          @receipt_number = StringField.new(prediction['receipt_number'], page_id)
          @subcategory = ClassificationField.new(prediction['subcategory'], page_id)
          @supplier_address = StringField.new(prediction['supplier_address'], page_id)
          @supplier_company_registrations = []
          prediction['supplier_company_registrations'].each do |item|
            @supplier_company_registrations.push(Parsing::Standard::CompanyRegistrationField.new(item, page_id))
          end
          @supplier_name = StringField.new(prediction['supplier_name'], page_id)
          @supplier_phone_number = StringField.new(prediction['supplier_phone_number'], page_id)
          @taxes = Taxes.new(prediction['taxes'], page_id)
          @time = StringField.new(prediction['time'], page_id)
          @tip = AmountField.new(prediction['tip'], page_id)
          @total_amount = AmountField.new(prediction['total_amount'], page_id)
          @total_net = AmountField.new(prediction['total_net'], page_id)
          @total_tax = AmountField.new(prediction['total_tax'], page_id)
        end

        # @return [String]
        def to_s
          supplier_company_registrations = @supplier_company_registrations.join("\n #{' ' * 32}")
          line_items = line_items_to_s
          out_str = String.new
          out_str << "\n:Expense Locale: #{@locale}".rstrip
          out_str << "\n:Purchase Category: #{@category}".rstrip
          out_str << "\n:Purchase Subcategory: #{@subcategory}".rstrip
          out_str << "\n:Document Type: #{@document_type}".rstrip
          out_str << "\n:Purchase Date: #{@date}".rstrip
          out_str << "\n:Purchase Time: #{@time}".rstrip
          out_str << "\n:Total Amount: #{@total_amount}".rstrip
          out_str << "\n:Total Net: #{@total_net}".rstrip
          out_str << "\n:Total Tax: #{@total_tax}".rstrip
          out_str << "\n:Tip and Gratuity: #{@tip}".rstrip
          out_str << "\n:Taxes:#{@taxes}".rstrip
          out_str << "\n:Supplier Name: #{@supplier_name}".rstrip
          out_str << "\n:Supplier Company Registrations: #{supplier_company_registrations}".rstrip
          out_str << "\n:Supplier Address: #{@supplier_address}".rstrip
          out_str << "\n:Supplier Phone Number: #{@supplier_phone_number}".rstrip
          out_str << "\n:Receipt Number: #{@receipt_number}".rstrip
          out_str << "\n:Line Items:"
          out_str << line_items
          out_str[1..].to_s
        end

        private

        # @param char [String]
        # @return [String]
        def line_items_separator(char)
          out_str = String.new
          out_str << '  '
          out_str << "+#{char * 38}"
          out_str << "+#{char * 10}"
          out_str << "+#{char * 14}"
          out_str << "+#{char * 12}"
          out_str << '+'
          out_str
        end

        # @return [String]
        def line_items_to_s
          return '' if @line_items.empty?

          line_items = @line_items.map(&:to_table_line).join("\n#{line_items_separator('-')}\n  ")
          out_str = String.new
          out_str << "\n#{line_items_separator('-')}"
          out_str << "\n  |"
          out_str << ' Description                          |'
          out_str << ' Quantity |'
          out_str << ' Total Amount |'
          out_str << ' Unit Price |'
          out_str << "\n#{line_items_separator('=')}"
          out_str << "\n  #{line_items}"
          out_str << "\n#{line_items_separator('-')}"
          out_str
        end
      end
    end
  end
end
