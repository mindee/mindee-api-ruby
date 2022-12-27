# frozen_string_literal: true

require_relative 'common_fields'
require_relative 'base'
require_relative 'invoice/invoice_v3'
require_relative 'receipt/receipt_v3'

module Mindee
  # Union of `Invoice` and `Receipt`.
  class FinancialDocument < Prediction
    # @return [Mindee::Locale]
    attr_reader :locale
    # @return [Mindee::Amount]
    attr_reader :total_incl
    # @return [Mindee::Amount]
    attr_reader :total_excl
    # @return [Mindee::Amount]
    attr_reader :total_tax
    # @return [Mindee::DateField]
    attr_reader :date
    # @return [Mindee::Field]
    attr_reader :category
    # @return [Mindee::Field]
    attr_reader :invoice_number
    # @return [Mindee::Field]
    attr_reader :time
    # @return [Mindee::DateField]
    attr_reader :due_date
    # @return [Array<Mindee::TaxField>]
    attr_reader :taxes
    # @return [Mindee::Field]
    attr_reader :supplier
    # @return [Mindee::Field]
    attr_reader :supplier_address
    # @return [Mindee::Field]
    attr_reader :customer_name
    # @return [Mindee::Field]
    attr_reader :customer_address
    # @return [Array<Mindee::CompanyRegistration>]
    attr_reader :company_registration
    # @return [Array<Mindee::CompanyRegistration>]
    attr_reader :customer_company_registration
    # @return [Array<Mindee::PaymentDetails>]
    attr_reader :payment_details

    # @param prediction [Hash]
    # @param input_file [Mindee::InputDocument, nil]
    # @param page_id [Integer, nil]
    def initialize(prediction, input_file: nil, page_id: nil)
      super()
      @locale = Locale.new(prediction['locale'])
      if prediction.include? 'invoice_number'
        build_from_invoice(
          Invoice.new(prediction, input_file: input_file, page_id: page_id)
        )
      else
        build_from_receipt(
          Receipt.new(prediction, input_file: input_file, page_id: page_id)
        )
      end
    end

    def to_s
      customer_company_registration = @customer_company_registration.map(&:value).join('; ')
      payment_details = @payment_details.map(&:to_s).join("\n                 ")
      company_registration = @company_registration.map(&:to_s).join('; ')
      taxes = @taxes.join("\n       ")
      out_str = String.new
      out_str << '-----Financial Document data-----'
      out_str << "\nFilename: #{@filename}".rstrip
      out_str << "\nCategory: #{@category}".rstrip
      out_str << "\nInvoice number: #{@invoice_number}".rstrip
      out_str << "\nTotal amount including taxes: #{@total_incl}".rstrip
      out_str << "\nTotal amount excluding taxes: #{@total_excl}".rstrip
      out_str << "\nInvoice date: #{@date}".rstrip
      out_str << "\nInvoice due date: #{@due_date}".rstrip
      out_str << "\nSupplier name: #{@supplier}".rstrip
      out_str << "\nSupplier address: #{@supplier_address}".rstrip
      out_str << "\nCustomer name: #{@customer_name}".rstrip
      out_str << "\nCustomer company registration: #{customer_company_registration}".rstrip
      out_str << "\nCustomer address: #{@customer_address}".rstrip
      out_str << "\nPayment details: #{payment_details}".rstrip
      out_str << "\nCompany numbers: #{company_registration}".rstrip
      out_str << "\nTaxes: #{taxes}".rstrip
      out_str << "\nTotal taxes: #{@total_tax}".rstrip
      out_str << "\nTime: #{@time}".rstrip
      out_str << "\nLocale: #{@locale}".rstrip
      out_str << "\n----------------------"
      out_str
    end

    private

    # @param invoice [Mindee::Invoice]
    def build_from_invoice(invoice)
      @category = empty_field
      @total_incl = invoice.total_incl
      @total_excl = invoice.total_excl
      @total_tax = invoice.total_tax
      @date = invoice.date
      @time = empty_field
      @due_date = invoice.due_date
      @invoice_number = invoice.invoice_number
      @taxes = invoice.taxes
      @supplier = invoice.supplier
      @supplier_address = invoice.supplier_address
      @company_registration = invoice.company_registration
      @customer_company_registration = invoice.customer_company_registration
      @payment_details = invoice.payment_details
    end

    # @param receipt [Mindee::Receipt]
    def build_from_receipt(receipt)
      @category = receipt.category
      @total_incl = receipt.total_incl
      @total_excl = receipt.total_excl
      @total_tax = receipt.total_tax
      @date = receipt.date
      @time = receipt.time
      @due_date = empty_field
      @taxes = receipt.taxes
      @supplier = receipt.supplier
      @supplier_address = empty_field
      @company_registration = empty_field
      @customer_company_registration = empty_field
      @payment_details = empty_field
    end

    def empty_field
      Mindee::Field.new({}, nil)
    end
  end
end
