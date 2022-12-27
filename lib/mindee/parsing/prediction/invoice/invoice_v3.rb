# frozen_string_literal: true

require_relative '../common_fields'
require_relative '../base'

module Mindee
  # Invoice document.
  class InvoiceV3 < Prediction
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
    attr_reader :invoice_number
    # @return [Mindee::DateField]
    attr_reader :due_date
    # @return [Array<Mindee::TaxField>]
    attr_reader :taxes
    # @return [Array<Mindee::CompanyRegistration>]
    attr_reader :customer_company_registration
    # @return [Array<Mindee::PaymentDetails>]
    attr_reader :payment_details
    # @return [Array<Mindee::CompanyRegistration>]
    attr_reader :company_registration
    # @return [Mindee::Field]
    attr_reader :customer_name
    # @return [Mindee::Field]
    attr_reader :supplier
    # @return [Mindee::Field]
    attr_reader :supplier_address
    # @return [Mindee::Field]
    attr_reader :customer_address
    # @return [Mindee::Orientation]
    attr_reader :orientation

    # @param prediction [Hash]
    # @param page_id [Integer, nil]
    def initialize(prediction, page_id)
      super()
      @locale = Locale.new(prediction['locale'])
      @total_incl = Amount.new(prediction['total_incl'], page_id)
      @total_excl = Amount.new(prediction['total_excl'], page_id)
      @customer_address = Field.new(prediction['customer_address'], page_id)
      @customer_name = Field.new(prediction['customer'], page_id)
      @date = DateField.new(prediction['date'], page_id)
      @due_date = DateField.new(prediction['due_date'], page_id)
      @invoice_number = Field.new(prediction['invoice_number'], page_id)
      @supplier = Field.new(prediction['supplier'], page_id)
      @supplier_address = Field.new(prediction['supplier_address'], page_id)

      @customer_company_registration = []
      prediction['customer_company_registration'].each do |item|
        @customer_company_registration.push(CompanyRegistration.new(item, page_id))
      end
      @taxes = []
      prediction['taxes'].each do |item|
        @taxes.push(TaxField.new(item, page_id))
      end
      @payment_details = []
      prediction['payment_details'].each do |item|
        @payment_details.push(PaymentDetails.new(item, page_id))
      end
      @company_registration = []
      prediction['company_registration'].each do |item|
        @company_registration.push(CompanyRegistration.new(item, page_id))
      end

      @total_tax = Amount.new(
        { value: nil, confidence: 0.0 }, page_id
      )
      reconstruct(page_id)
    end

    def to_s
      customer_company_registration = @customer_company_registration.map(&:value).join('; ')
      payment_details = @payment_details.map(&:to_s).join("\n                 ")
      company_registration = @company_registration.map(&:to_s).join('; ')
      taxes = @taxes.join("\n       ")
      out_str = String.new
      out_str << '----- Invoice V3 -----'
      out_str << "\nFilename: #{@filename}".rstrip
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
      out_str << "\nLocale: #{@locale}".rstrip
      out_str << "\n----------------------"
      out_str
    end

    private

    def reconstruct(page_id)
      construct_total_tax_from_taxes(page_id)
      construct_total_excl_from_tcc_and_taxes(page_id)
      construct_total_incl_from_taxes_plus_excl(page_id)
      construct_total_tax_from_totals(page_id)
    end

    def construct_total_excl_from_tcc_and_taxes(page_id)
      return if @total_incl.value.nil? || taxes.empty? || !@total_excl.value.nil?

      total_excl = {
        'value' => @total_incl.value - @taxes.map(&:value).sum,
        'confidence' => Field.array_confidence(@taxes) * @total_incl.confidence,
      }
      @total_excl = Amount.new(total_excl, page_id, reconstructed: true)
    end

    def construct_total_incl_from_taxes_plus_excl(page_id)
      return if @total_excl.value.nil? || @taxes.empty? || !@total_incl.value.nil?

      total_incl = {
        'value' => @taxes.map(&:value).sum + @total_excl.value,
        'confidence' => Field.array_confidence(@taxes) * @total_excl.confidence,
      }
      @total_incl = Amount.new(total_incl, page_id, reconstructed: true)
    end

    def construct_total_tax_from_taxes(page_id)
      return if @taxes.empty?

      total_tax = {
        'value' => @taxes.map(&:value).sum,
        'confidence' => Field.array_confidence(@taxes),
      }
      return unless total_tax['value'].positive?

      @total_tax = Amount.new(total_tax, page_id, reconstructed: true)
    end

    def construct_total_tax_from_totals(page_id)
      return if !@total_tax.value.nil? || @total_incl.value.nil? || @total_excl.value.nil?

      total_tax = {
        'value' => @total_incl.value - @total_excl.value,
        'confidence' => Field.array_confidence(@taxes),
      }
      return unless total_tax['value'] >= 0

      @total_tax = Amount.new(total_tax, page_id, reconstructed: true)
    end
  end
end
