# frozen_string_literal: true

require_relative '../fields'
require_relative 'base'
require_relative 'invoice'
require_relative 'receipt'

module Mindee
  # Union of `Invoice` and `Receipt`.
  class FinancialDocument < Document
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
    attr_reader :invoice_number,
                :orientation

    # @param input_file [Mindee::InputDocument]
    def initialize(prediction, input_file: nil, page_id: nil)
      super('financial_doc', input_file: input_file)
      @locale = Locale.new(prediction['locale'])
      if prediction.include? 'invoice_number'
        build_from_invoice(Invoice.new(prediction, page_id))
      else
        build_from_receipt(Receipt.new(prediction, page_id))
      end
    end

    def to_s
      out_str = String.new
      out_str << '-----Financial Document data-----'
      out_str << "\nFilename: #{@filename}".rstrip
      out_str << "\nInvoice number: #{@invoice_number}".rstrip
      out_str << "\nTotal amount including taxes: #{@total_incl}".rstrip
      out_str << "\nTotal amount excluding taxes: #{@total_excl}".rstrip
      out_str << "\n----------------------"
      out_str
    end

    private

    # @param invoice [Mindee::Invoice]
    def build_from_invoice(invoice)
      @orientation = invoice.orientation
      @total_incl = invoice.total_incl
      @total_excl = invoice.total_excl
      @total_tax = invoice.total_tax
      @date = invoice.invoice_date
      @invoice_number = invoice.invoice_number
    end

    # @param receipt [Mindee::Receipt]
    def build_from_receipt(receipt)
      @orientation = receipt.orientation
      @total_incl = receipt.total_incl
      @total_excl = receipt.total_excl
      @total_tax = invoice.total_tax
    end
  end
end
