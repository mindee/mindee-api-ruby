# frozen_string_literal: true

require_relative '../fields'
require_relative 'base'

module Mindee
  # Invoice document.
  class Invoice < Document
    attr_reader :locale,
                :total_incl,
                :total_excl,
                :invoice_date,
                :invoice_number,
                :due_date,
                :taxes,
                :total_tax,
                :supplier,
                :supplier_address,
                :customer_name,
                :customer_address,
                :customer_company_registration,
                :payment_details,
                :company_number,
                :orientation

    def initialize(prediction, page_id)
      super('invoice')
      @orientation = Orientation.new(prediction['orientation'], page_id) if page_id
      @locale = Locale.new(prediction['locale'])
      @total_incl = Field.new(prediction['total_incl'], page_id)
      @total_excl = Field.new(prediction['total_excl'], page_id)
      @customer_address = Field.new(prediction['customer_address'], page_id)
      @customer_name = Field.new(prediction['customer'], page_id)
      @invoice_date = DateField.new(prediction['date'], page_id)
      @due_date = DateField.new(prediction['due_date'], page_id)
      @invoice_number = Field.new(prediction['invoice_number'], page_id)
      @supplier = Field.new(prediction['supplier'], page_id)
      @supplier_address = Field.new(prediction['supplier_address'], page_id)

      @customer_company_registration = []
      prediction['customer_company_registration'].each do |item|
        @customer_company_registration.push(Field.new(item, page_id))
      end
      @taxes = []
      prediction['taxes'].each do |item|
        @taxes.push(Tax.new(item, page_id))
      end
      @payment_details = []
      prediction['payment_details'].each do |item|
        @payment_details.push(PaymentDetails.new(item, page_id))
      end
      @company_number = []
      prediction['company_registration'].each do |item|
        @company_number.push(Field.new(item, page_id))
      end

      @total_tax = construct_total_tax(page_id)
    end

    def to_s
      customer_company_registration = @customer_company_registration.map(&:value).join('; ')
      payments = @payment_details.map(&:to_s).join(' ')
      company_number = @company_number.map(&:to_s).join('; ')
      taxes = @taxes.join(' ')
      out_str = String.new
      out_str << '-----Invoice data-----'
      out_str << "\nFilename: #{@filename}".rstrip
      out_str << "\nInvoice number: #{@invoice_number}".rstrip
      out_str << "\nTotal amount including taxes: #{@total_incl}".rstrip
      out_str << "\nTotal amount excluding taxes: #{@total_excl}".rstrip
      out_str << "\nInvoice date: #{@invoice_date}".rstrip
      out_str << "\nInvoice due date: #{@due_date}".rstrip
      out_str << "\nSupplier name: #{@supplier}".rstrip
      out_str << "\nSupplier address: #{@supplier_address}".rstrip
      out_str << "\nCustomer name: #{@customer_name}".rstrip
      out_str << "\nCustomer company registration: #{customer_company_registration}".rstrip
      out_str << "\nCustomer address: #{@customer_address}".rstrip
      out_str << "\nPayment details: #{payments}".rstrip
      out_str << "\nCompany numbers: #{company_number}".rstrip
      out_str << "\nTaxes: #{taxes}".rstrip
      out_str << "\nTotal taxes: #{@total_tax}".rstrip
      out_str << "\nLocale: #{@locale}".rstrip
      out_str << "\n----------------------"
      out_str
    end

    private

    def construct_total_tax(page_id)
      return unless @taxes

      total_tax = {
        'value' => @taxes.map(&:value).sum,
        'confidence' => Field.array_confidence(@taxes),
      }
      Field.new(total_tax, page_id, reconstructed: true)
    end
  end
end
