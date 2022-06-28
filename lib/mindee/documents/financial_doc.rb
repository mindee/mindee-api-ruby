# frozen_string_literal: true

require_relative '../fields'
require_relative 'base'
require_relative 'invoice'
require_relative 'receipt'

module Mindee
  # Union of `Invoice` and `Receipt`.
  class FinancialDocument < Document
    attr_reader :locale,
                :total_incl,
                :total_excl,
                :date,
                :invoice_number,
                :orientation

    def initialize(prediction, page_id)
      super('financial_doc')
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

    def build_from_invoice(invoice)
      @orientation = invoice.orientation
      @total_incl = invoice.total_incl
      @total_excl = invoice.total_excl
      @date = invoice.invoice_date
      @invoice_number = invoice.invoice_number
    end

    def build_from_receipt(receipt)
      @orientation = receipt.orientation
      @total_incl = receipt.total_incl
      @total_excl = receipt.total_excl
    end
  end
end
