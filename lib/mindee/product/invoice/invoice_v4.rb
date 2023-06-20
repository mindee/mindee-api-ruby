# frozen_string_literal: true

require_relative 'invoice_v4_document'

module Mindee
  module Product
    # Invoice document.
    class InvoiceV4 < InvoiceV4Document
      @endpoint_name = 'invoices'
      @endpoint_version = '4'

      class << self
        attr_reader :endpoint_name, :endpoint_version
      end
    end
  end
end
