# frozen_string_literal: true

require_relative '../fields'
require_relative 'base'

module Mindee
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
                :company_numbers

    def initialize(response)
      super()
      prediction = response['document']['inference']['prediction']
      @locale = Locale.new(prediction['locale'])
      @total_incl = Field.new(prediction['total_incl'])
      @total_excl = Field.new(prediction['total_excl'])
      @customer_address = Field.new(prediction['customer_address'])
      @customer_name = Field.new(prediction['customer'])
      @invoice_date = DateField.new(prediction['date'])
      @due_date = DateField.new(prediction['due_date'])
      @invoice_number = Field.new(prediction['invoice_number'])
      @supplier = Field.new(prediction['supplier'])
      @supplier_address = Field.new(prediction['supplier_address'])

      @customer_company_registration = []
      prediction['customer_company_registration'].each do |item|
        @customer_company_registration.push(Field.new(item))
      end
      @taxes = []
      prediction['taxes'].each do |item|
        @taxes.push(Tax.new(item))
      end
      @payment_details = []
      prediction['payment_details'].each do |item|
        @payment_details.push(Field.new(item))
      end
      @company_numbers = []
      prediction['company_registration'].each do |item|
        @company_numbers.push(Field.new(item))
      end
    end

    def to_s
      customer_company_registration = @customer_company_registration.map(&:value).join(' ')
      payments = @payment_details.map(&:value).join(' ')
      company_numbers = @company_numbers.map(&:value).join(' ')
      taxes = @taxes.join(' ')
      "-----Invoice data-----\n" \
        "Filename: #{@filename}\n" \
        "Invoice number: #{@invoice_number}\n" \
        "Total amount including taxes: #{@total_incl}\n" \
        "Total amount excluding taxes: #{@total_excl}\n" \
        "Invoice date: #{@invoice_date}\n" \
        "Invoice due date: #{@due_date}\n" \
        "Supplier name: #{@supplier}\n" \
        "Supplier address: #{@supplier_address}\n" \
        "Customer name: #{@customer_name}\n" \
        "Customer company registration: #{customer_company_registration}\n" \
        "Customer address: #{@customer_address}\n" \
        "Payment details: #{payments}\n" \
        "Company numbers: #{company_numbers}\n" \
        "Taxes: #{taxes}\n" \
        "Total taxes: #{@total_tax}\n" \
        "Locale: #{@locale}\n" \
        '----------------------'
    end
  end
end
