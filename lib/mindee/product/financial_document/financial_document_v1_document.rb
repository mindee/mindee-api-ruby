# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'financial_document_v1_line_item'

module Mindee
  module Product
    module FinancialDocument
      # Financial Document v1 document prediction.
      class FinancialDocumentV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # The purchase category among predefined classes.
        # @return [Mindee::Parsing::Standard::ClassificationField]
        attr_reader :category
        # The address of the customer.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :customer_address
        # List of company registrations associated to the customer.
        # @return [Array<Mindee::Parsing::Standard::CompanyRegistration>]
        attr_reader :customer_company_registrations
        # The name of the customer.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :customer_name
        # The date the purchase was made.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :date
        # One of: 'INVOICE', 'CREDIT NOTE', 'CREDIT CARD RECEIPT', 'EXPENSE RECEIPT'.
        # @return [Mindee::Parsing::Standard::ClassificationField]
        attr_reader :document_type
        # The date on which the payment is due.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :due_date
        # The invoice number or identifier.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :invoice_number
        # List of line item details.
        # @return [Array<Mindee::FinancialDocumentV1LineItem>]
        attr_reader :line_items
        # The locale detected on the document.
        # @return [Mindee::Parsing::Standard::Locale]
        attr_reader :locale
        # List of Reference numbers, including PO number.
        # @return [Array<Mindee::Parsing::Standard::TextField>]
        attr_reader :reference_numbers
        # The purchase subcategory among predefined classes for transport and food.
        # @return [Mindee::Parsing::Standard::ClassificationField]
        attr_reader :subcategory
        # The address of the supplier or merchant.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :supplier_address
        # List of company registrations associated to the supplier.
        # @return [Array<Mindee::Parsing::Standard::CompanyRegistration>]
        attr_reader :supplier_company_registrations
        # The name of the supplier or merchant.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :supplier_name
        # List of payment details associated to the supplier.
        # @return [Array<Mindee::Parsing::Standard::PaymentDetails>]
        attr_reader :supplier_payment_details
        # The phone number of the supplier or merchant.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :supplier_phone_number
        # List of tax lines information.
        # @return [Mindee::Parsing::Standard::Taxes]
        attr_reader :taxes
        # The time the purchase was made.
        # @return [Mindee::Parsing::Standard::TextField]
        attr_reader :time
        # The total amount of tip and gratuity
        # @return [Mindee::Parsing::Standard::AmountField]
        attr_reader :tip
        # The total amount paid: includes taxes, tips, fees, and other charges.
        # @return [Mindee::Parsing::Standard::AmountField]
        attr_reader :total_amount
        # The net amount paid: does not include taxes, fees, and discounts.
        # @return [Mindee::Parsing::Standard::AmountField]
        attr_reader :total_net
        # The total amount of taxes.
        # @return [Mindee::Parsing::Standard::AmountField]
        attr_reader :total_tax

        # @param prediction [Hash]
        # @page_id [Integer, nil]
        def initialize(prediction, page_id)
          super()
          @category = ClassificationField.new(prediction['category'], page_id)
          @customer_address = TextField.new(prediction['customer_address'], page_id)
          @customer_company_registrations = []
          prediction['customer_company_registrations'].each do |item|
            @customer_company_registrations.push(CompanyRegistration.new(item, page_id))
          end
          @customer_name = TextField.new(prediction['customer_name'], page_id)
          @date = DateField.new(prediction['date'], page_id)
          @document_type = ClassificationField.new(prediction['document_type'], page_id)
          @due_date = DateField.new(prediction['due_date'], page_id)
          @invoice_number = TextField.new(prediction['invoice_number'], page_id)
          @line_items = []
          prediction['line_items'].each do |item|
            @line_items.push(FinancialDocumentV1LineItem.new(item, page_id))
          end
          @locale = Locale.new(prediction['locale'], page_id)
          @reference_numbers = []
          prediction['reference_numbers'].each do |item|
            @reference_numbers.push(TextField.new(item, page_id))
          end
          @subcategory = ClassificationField.new(prediction['subcategory'], page_id)
          @supplier_address = TextField.new(prediction['supplier_address'], page_id)
          @supplier_company_registrations = []
          prediction['supplier_company_registrations'].each do |item|
            @supplier_company_registrations.push(CompanyRegistration.new(item, page_id))
          end
          @supplier_name = TextField.new(prediction['supplier_name'], page_id)
          @supplier_payment_details = []
          prediction['supplier_payment_details'].each do |item|
            @supplier_payment_details.push(PaymentDetails.new(item, page_id))
          end
          @supplier_phone_number = TextField.new(prediction['supplier_phone_number'], page_id)
          @taxes = Taxes.new(prediction['taxes'], page_id)
          @time = TextField.new(prediction['time'], page_id)
          @tip = AmountField.new(prediction['tip'], page_id)
          @total_amount = AmountField.new(prediction['total_amount'], page_id)
          @total_net = AmountField.new(prediction['total_net'], page_id)
          @total_tax = AmountField.new(prediction['total_tax'], page_id)
        end

        # @return [String]
        def to_s
          reference_numbers = @reference_numbers.join("\n #{' ' * 19}")
          supplier_payment_details = @supplier_payment_details.join("\n #{' ' * 26}")
          supplier_company_registrations = @supplier_company_registrations.join("\n #{' ' * 32}")
          customer_company_registrations = @customer_company_registrations.join("\n #{' ' * 32}")
          line_items = line_items_to_s
          out_str = String.new
          out_str << "\n:Locale: #{@locale}".rstrip
          out_str << "\n:Invoice Number: #{@invoice_number}".rstrip
          out_str << "\n:Reference Numbers: #{reference_numbers}".rstrip
          out_str << "\n:Purchase Date: #{@date}".rstrip
          out_str << "\n:Due Date: #{@due_date}".rstrip
          out_str << "\n:Total Net: #{@total_net}".rstrip
          out_str << "\n:Total Amount: #{@total_amount}".rstrip
          out_str << "\n:Taxes:#{@taxes}".rstrip
          out_str << "\n:Supplier Payment Details: #{supplier_payment_details}".rstrip
          out_str << "\n:Supplier name: #{@supplier_name}".rstrip
          out_str << "\n:Supplier Company Registrations: #{supplier_company_registrations}".rstrip
          out_str << "\n:Supplier Address: #{@supplier_address}".rstrip
          out_str << "\n:Supplier Phone Number: #{@supplier_phone_number}".rstrip
          out_str << "\n:Customer name: #{@customer_name}".rstrip
          out_str << "\n:Customer Company Registrations: #{customer_company_registrations}".rstrip
          out_str << "\n:Customer Address: #{@customer_address}".rstrip
          out_str << "\n:Document Type: #{@document_type}".rstrip
          out_str << "\n:Purchase Subcategory: #{@subcategory}".rstrip
          out_str << "\n:Purchase Category: #{@category}".rstrip
          out_str << "\n:Total Tax: #{@total_tax}".rstrip
          out_str << "\n:Tip and Gratuity: #{@tip}".rstrip
          out_str << "\n:Purchase Time: #{@time}".rstrip
          out_str << "\n:Line Items:"
          out_str << line_items
          out_str[1..].to_s
        end

        private

        def line_items_separator(char)
          "  +#{char * 38}+#{char * 14}+#{char * 10}+#{char * 12}+#{char * 14}+#{char * 14}+#{char * 12}+"
        end

        def line_items_to_s
          return '' if @line_items.empty?

          line_items = @line_items.map(&:to_table_line).join("\n#{line_items_separator('-')}\n  ")
          out_str = String.new
          out_str << "\n#{line_items_separator('-')}"
          out_str << "\n  |"
          out_str << ' Description                          |'
          out_str << ' Product code |'
          out_str << ' Quantity |'
          out_str << ' Tax Amount |'
          out_str << ' Tax Rate (%) |'
          out_str << ' Total Amount |'
          out_str << ' Unit Price |'
          out_str << "\n#{line_items_separator('=')}"
          out_str << "\n  #{line_items}"
          out_str << "\n#{line_items_separator('-')}"
        end
      end
    end
  end
end
