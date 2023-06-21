# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'invoice_v4_document'
require_relative 'invoice_v4_page'

module Mindee
  module Product
    # Invoice document.
    class InvoiceV4 < Inference
      @endpoint_name = 'invoices'
      @endpoint_version = '4'

      class << self
        attr_reader :endpoint_name, :endpoint_version
      end
    end
  end
end
