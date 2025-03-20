# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'financial_document_v1_line_items'

module Mindee
  module Product
    module FinancialDocument
      # Financial Document API version 1.11 document data.
      class FinancialDocumentV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # The customer's address used for billing.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :billing_address
        # The purchase category, only for receipts.
        # @return [Mindee::Parsing::Standard::ClassificationField]
        attr_reader :category
        # The address of the customer.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :customer_address
        # List of company registration numbers associated to the customer.
        # @return [Array<Mindee::Parsing::Standard::CompanyRegistrationField>]
        attr_reader :customer_company_registrations
        # The customer account number or identifier from the supplier.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :customer_id
        # The name of the customer.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :customer_name
        # The date the purchase was made.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :date
        # The document number or identifier (invoice number or receipt number).
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :document_number
        # The type of the document: INVOICE or CREDIT NOTE if it is an invoice, CREDIT CARD RECEIPT or EXPENSE
        # RECEIPT if it is a receipt.
        # @return [Mindee::Parsing::Standard::ClassificationField]
        attr_reader :document_type
        # The date on which the payment is due.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :due_date
        # The invoice number or identifier only if document is an invoice.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :invoice_number
        # List of line item present on the document.
        # @return [Mindee::Product::FinancialDocument::FinancialDocumentV1LineItems]
        attr_reader :line_items
        # The locale of the document.
        # @return [Mindee::Parsing::Standard::LocaleField]
        attr_reader :locale
        # The date on which the payment is due / fullfilled.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :payment_date
        # The purchase order number, only if the document is an invoice.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :po_number
        # The receipt number or identifier only if document is a receipt.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :receipt_number
        # List of Reference numbers, including PO number, only if the document is an invoice.
        # @return [Array<Mindee::Parsing::Standard::StringField>]
        attr_reader :reference_numbers
        # The customer's address used for shipping.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :shipping_address
        # The purchase subcategory for transport and food, only for receipts.
        # @return [Mindee::Parsing::Standard::ClassificationField]
        attr_reader :subcategory
        # The address of the supplier or merchant.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :supplier_address
        # List of company registration numbers associated to the supplier.
        # @return [Array<Mindee::Parsing::Standard::CompanyRegistrationField>]
        attr_reader :supplier_company_registrations
        # The email of the supplier or merchant.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :supplier_email
        # The name of the supplier or merchant.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :supplier_name
        # List of payment details associated to the supplier (only for invoices).
        # @return [Array<Mindee::Parsing::Standard::PaymentDetailsField>]
        attr_reader :supplier_payment_details
        # The phone number of the supplier or merchant.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :supplier_phone_number
        # The website URL of the supplier or merchant.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :supplier_website
        # List of all taxes on the document.
        # @return [Mindee::Parsing::Standard::Taxes]
        attr_reader :taxes
        # The time the purchase was made (only for receipts).
        # @return [Mindee::Parsing::Standard::StringField]
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
        # The sum of all taxes present on the document.
        # @return [Mindee::Parsing::Standard::AmountField]
        attr_reader :total_tax

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @billing_address = Parsing::Standard::StringField.new(
            prediction['billing_address'],
            page_id
          )
          @category = Parsing::Standard::ClassificationField.new(
            prediction['category'],
            page_id
          )
          @customer_address = Parsing::Standard::StringField.new(
            prediction['customer_address'],
            page_id
          )
          @customer_company_registrations = [] # : Array[Parsing::Standard::CompanyRegistrationField]
          prediction['customer_company_registrations'].each do |item|
            @customer_company_registrations.push(Parsing::Standard::CompanyRegistrationField.new(item, page_id))
          end
          @customer_id = Parsing::Standard::StringField.new(
            prediction['customer_id'],
            page_id
          )
          @customer_name = Parsing::Standard::StringField.new(
            prediction['customer_name'],
            page_id
          )
          @date = Parsing::Standard::DateField.new(prediction['date'], page_id)
          @document_number = Parsing::Standard::StringField.new(
            prediction['document_number'],
            page_id
          )
          @document_type = Parsing::Standard::ClassificationField.new(
            prediction['document_type'],
            page_id
          )
          @due_date = Parsing::Standard::DateField.new(
            prediction['due_date'],
            page_id
          )
          @invoice_number = Parsing::Standard::StringField.new(
            prediction['invoice_number'],
            page_id
          )
          @line_items = Product::FinancialDocument::FinancialDocumentV1LineItems.new(
            prediction['line_items'], page_id
          )
          @locale = Parsing::Standard::LocaleField.new(
            prediction['locale'],
            page_id
          )
          @payment_date = Parsing::Standard::DateField.new(
            prediction['payment_date'],
            page_id
          )
          @po_number = Parsing::Standard::StringField.new(
            prediction['po_number'],
            page_id
          )
          @receipt_number = Parsing::Standard::StringField.new(
            prediction['receipt_number'],
            page_id
          )
          @reference_numbers = [] # : Array[Parsing::Standard::StringField]
          prediction['reference_numbers'].each do |item|
            @reference_numbers.push(Parsing::Standard::StringField.new(item, page_id))
          end
          @shipping_address = Parsing::Standard::StringField.new(
            prediction['shipping_address'],
            page_id
          )
          @subcategory = Parsing::Standard::ClassificationField.new(
            prediction['subcategory'],
            page_id
          )
          @supplier_address = Parsing::Standard::StringField.new(
            prediction['supplier_address'],
            page_id
          )
          @supplier_company_registrations = [] # : Array[Parsing::Standard::CompanyRegistrationField]
          prediction['supplier_company_registrations'].each do |item|
            @supplier_company_registrations.push(Parsing::Standard::CompanyRegistrationField.new(item, page_id))
          end
          @supplier_email = Parsing::Standard::StringField.new(
            prediction['supplier_email'],
            page_id
          )
          @supplier_name = Parsing::Standard::StringField.new(
            prediction['supplier_name'],
            page_id
          )
          @supplier_payment_details = [] # : Array[Parsing::Standard::PaymentDetailsField]
          prediction['supplier_payment_details'].each do |item|
            @supplier_payment_details.push(Parsing::Standard::PaymentDetailsField.new(item, page_id))
          end
          @supplier_phone_number = Parsing::Standard::StringField.new(
            prediction['supplier_phone_number'],
            page_id
          )
          @supplier_website = Parsing::Standard::StringField.new(
            prediction['supplier_website'],
            page_id
          )
          @taxes = Parsing::Standard::Taxes.new(prediction['taxes'], page_id)
          @time = Parsing::Standard::StringField.new(prediction['time'], page_id)
          @tip = Parsing::Standard::AmountField.new(prediction['tip'], page_id)
          @total_amount = Parsing::Standard::AmountField.new(
            prediction['total_amount'],
            page_id
          )
          @total_net = Parsing::Standard::AmountField.new(
            prediction['total_net'],
            page_id
          )
          @total_tax = Parsing::Standard::AmountField.new(
            prediction['total_tax'],
            page_id
          )
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
          out_str << "\n:Purchase Order Number: #{@po_number}".rstrip
          out_str << "\n:Receipt Number: #{@receipt_number}".rstrip
          out_str << "\n:Document Number: #{@document_number}".rstrip
          out_str << "\n:Reference Numbers: #{reference_numbers}".rstrip
          out_str << "\n:Purchase Date: #{@date}".rstrip
          out_str << "\n:Due Date: #{@due_date}".rstrip
          out_str << "\n:Payment Date: #{@payment_date}".rstrip
          out_str << "\n:Total Net: #{@total_net}".rstrip
          out_str << "\n:Total Amount: #{@total_amount}".rstrip
          out_str << "\n:Taxes:#{@taxes}".rstrip
          out_str << "\n:Supplier Payment Details: #{supplier_payment_details}".rstrip
          out_str << "\n:Supplier Name: #{@supplier_name}".rstrip
          out_str << "\n:Supplier Company Registrations: #{supplier_company_registrations}".rstrip
          out_str << "\n:Supplier Address: #{@supplier_address}".rstrip
          out_str << "\n:Supplier Phone Number: #{@supplier_phone_number}".rstrip
          out_str << "\n:Customer Name: #{@customer_name}".rstrip
          out_str << "\n:Supplier Website: #{@supplier_website}".rstrip
          out_str << "\n:Supplier Email: #{@supplier_email}".rstrip
          out_str << "\n:Customer Company Registrations: #{customer_company_registrations}".rstrip
          out_str << "\n:Customer Address: #{@customer_address}".rstrip
          out_str << "\n:Customer ID: #{@customer_id}".rstrip
          out_str << "\n:Shipping Address: #{@shipping_address}".rstrip
          out_str << "\n:Billing Address: #{@billing_address}".rstrip
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

        # @param char [String]
        # @return [String]
        def line_items_separator(char)
          out_str = String.new
          out_str << '  '
          out_str << "+#{char * 38}"
          out_str << "+#{char * 14}"
          out_str << "+#{char * 10}"
          out_str << "+#{char * 12}"
          out_str << "+#{char * 14}"
          out_str << "+#{char * 14}"
          out_str << "+#{char * 17}"
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
          out_str << ' Product code |'
          out_str << ' Quantity |'
          out_str << ' Tax Amount |'
          out_str << ' Tax Rate (%) |'
          out_str << ' Total Amount |'
          out_str << ' Unit of measure |'
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
