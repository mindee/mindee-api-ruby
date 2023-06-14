# frozen_string_literal: true

require_relative '../common_fields'
require_relative '../base'
require_relative 'financial_document_v1_line_item'

module Mindee
  module Prediction
    # Invoice document.
    class FinancialDocumentV1 < Prediction
      # Locale information.
      # @return [Mindee::Locale]
      attr_reader :locale
      # The nature of the document.
      # @return [Mindee::TextField]
      attr_reader :document_type
      # The total amount with tax included.
      # @return [Mindee::AmountField]
      attr_reader :total_amount
      # The total amount without the tax value.
      # @return [Mindee::AmountField]
      attr_reader :total_net
      # The total tax.
      # @return [Mindee::AmountField]
      attr_reader :total_tax
      # The creation date of the document.
      # @return [Mindee::DateField]
      attr_reader :date
      # The invoice number.
      # @return [Mindee::TextField]
      attr_reader :invoice_number
      # List of Reference numbers including PO number.
      # @return [Mindee::TextField]
      attr_reader :reference_numbers
      # The due date of the invoice.
      # @return [Mindee::DateField]
      attr_reader :due_date
      # The list of taxes.
      # @return <Mindee::Taxes>
      attr_reader :taxes
      # The name of the customer.
      # @return [Mindee::TextField]
      attr_reader :customer_name
      # The address of the customer.
      # @return [Mindee::TextField]
      attr_reader :customer_address
      # The company registration information for the customer.
      # @return [Array<Mindee::CompanyRegistration>]
      attr_reader :customer_company_registrations
      # The supplier's name.
      # @return [Mindee::TextField]
      attr_reader :supplier_name
      # The supplier's address.
      # @return [Mindee::TextField]
      attr_reader :supplier_address
      # The supplier's payment information.
      # @return [Array<Mindee::PaymentDetails>]
      attr_reader :supplier_payment_details
      # The supplier's company registration information.
      # @return [Array<Mindee::CompanyRegistration>]
      attr_reader :supplier_company_registrations
      # The phone number of the supplier or merchant.
      # @return [Array<Mindee::TextField>]
      attr_reader :supplier_phone_number
      # Line items details.
      # @return [Array<Mindee::FinancialDocumentV1LineItem>]
      attr_reader :line_items
      # Time as seen on the receipt in HH:MM format.
      # @return [Mindee::TextField]
      attr_reader :time
      # The invoice or receipt category among predefined classes.
      # @return [Mindee::TextField]
      attr_reader :category
      # The invoice or receipt sub-category among predefined classes.
      # @return [Mindee::TextField]
      attr_reader :subcategory
      # A classification field, that can return 4 values:
      # `EXPENSE RECEIPT`, `CREDIT CARD RECEIPT`, `INVOICE`, `CREDIT NOTE`
      # @return [Mindee::TextField]
      attr_reader :document_type # rubocop:todo Lint/DuplicateMethods
      # Total amount of tip and gratuity. Both typed and handwritten characters are supported.
      # @return [Mindee::AmountField]
      attr_reader :tip

      # @param prediction [Hash]
      # @param page_id [Integer, nil]
      def initialize(prediction, page_id) # rubocop:todo Metrics/AbcSize
        super
        @time = TextField.new(prediction['time'], page_id)
        @category = TextField.new(prediction['category'], page_id)
        @subcategory = TextField.new(prediction['subcategory'], page_id)
        @document_type = TextField.new(prediction['document_type'], page_id)
        @tip = AmountField.new(prediction['tip'], page_id)
        @locale = Locale.new(prediction['locale'])
        @document_type = TextField.new(prediction['document_type'], page_id)
        @total_amount = AmountField.new(prediction['total_amount'], page_id)
        @total_net = AmountField.new(prediction['total_net'], page_id)
        @customer_address = TextField.new(prediction['customer_address'], page_id)
        @customer_name = TextField.new(prediction['customer_name'], page_id)
        @date = DateField.new(prediction['date'], page_id)
        @due_date = DateField.new(prediction['due_date'], page_id)
        @invoice_number = TextField.new(prediction['invoice_number'], page_id)
        @supplier_name = TextField.new(prediction['supplier_name'], page_id)
        @supplier_address = TextField.new(prediction['supplier_address'], page_id)
        @supplier_phone_number = TextField.new(prediction['supplier_phone_number'], page_id)
        @reference_numbers = []
        prediction['reference_numbers'].each do |item|
          @reference_numbers.push(TextField.new(item, page_id))
        end
        @customer_company_registrations = []
        prediction['customer_company_registrations'].each do |item|
          @customer_company_registrations.push(CompanyRegistration.new(item, page_id))
        end
        # @taxes = []
        # prediction['taxes'].each do |item|
        #   @taxes.push(TaxField.new(item, page_id))
        # end
        @taxes = Taxes.new(prediction['taxes'], page_id)
        @supplier_payment_details = []
        prediction['supplier_payment_details'].each do |item|
          @supplier_payment_details.push(PaymentDetails.new(item, page_id))
        end
        @supplier_company_registrations = []
        prediction['supplier_company_registrations'].each do |item|
          @supplier_company_registrations.push(CompanyRegistration.new(item, page_id))
        end
        @total_tax = AmountField.new(
          { value: nil, confidence: 0.0 }, page_id
        )
        @line_items = []
        prediction['line_items'].each do |item|
          @line_items.push(FinancialDocumentV1LineItem.new(item, page_id))
        end
        reconstruct(page_id)
      end

      def to_s
        customer_company_registrations = @customer_company_registrations.map(&:value).join('; ')
        supplier_payment_details = @supplier_payment_details.map(&:to_s).join("\n                 ")
        supplier_company_registrations = @supplier_company_registrations.map(&:to_s).join('; ')
        reference_numbers = @reference_numbers.map(&:to_s).join(', ')
        # taxes = @taxes.join("\n       ")
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
        out_str << line_items_to_s
        out_str[1..].to_s
      end

      private

      def line_item_separator(char)
        "  +#{char * 38}+#{char * 14}+#{char * 10}+#{char * 12}+#{char * 14}+#{char * 14}+#{char * 12}+"
      end

      def line_items_to_s
        return '' if @line_items.empty?

        out_str = String.new
        out_str << "\n#{line_item_separator('-')}"
        out_str << "\n  | Description#{' ' * 25} | Product code | Quantity | Tax Amount | Tax Rate (%) | Total Amount | Unit Price |"
        out_str << "\n#{line_item_separator('=')}"
        @line_items.each do |line_item|
          out_str << "\n  #{line_item.to_table_line}"
          out_str << "\n#{line_item_separator('-')}"
        end
        out_str
      end

      def reconstruct(page_id)
        construct_total_tax_from_taxes(page_id)
        return unless page_id.nil?

        construct_total_excl_from_tcc_and_taxes(page_id)
        construct_total_incl_from_taxes_plus_excl(page_id)
        construct_total_tax_from_totals(page_id)
      end

      def construct_total_excl_from_tcc_and_taxes(page_id)
        return if @total_amount.value.nil? || taxes.empty? || !@total_net.value.nil?

        total_excl = {
          'value' => @total_amount.value - @taxes.map(&:value).sum,
          'confidence' => TextField.array_confidence(@taxes) * @total_amount.confidence,
        }
        @total_net = AmountField.new(total_excl, page_id, reconstructed: true)
      end

      def construct_total_incl_from_taxes_plus_excl(page_id)
        return if @total_net.value.nil? || @taxes.empty? || !@total_amount.value.nil?

        total_incl = {
          'value' => @taxes.map(&:value).sum + @total_net.value,
          'confidence' => TextField.array_confidence(@taxes) * @total_net.confidence,
        }
        @total_amount = AmountField.new(total_incl, page_id, reconstructed: true)
      end

      def construct_total_tax_from_taxes(page_id)
        return if @taxes.empty?

        total_tax = {
          'value' => @taxes.map(&:value).sum,
          'confidence' => TextField.array_confidence(@taxes),
        }
        return unless total_tax['value'].positive?

        @total_tax = AmountField.new(total_tax, page_id, reconstructed: true)
      end

      def construct_total_tax_from_totals(page_id)
        return if !@total_tax.value.nil? || @total_amount.value.nil? || @total_net.value.nil?

        total_tax = {
          'value' => @total_amount.value - @total_net.value,
          'confidence' => TextField.array_confidence(@taxes),
        }
        return unless total_tax['value'] >= 0

        @total_tax = AmountField.new(total_tax, page_id, reconstructed: true)
      end
    end
  end
end
