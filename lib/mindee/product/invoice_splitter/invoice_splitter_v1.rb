# frozen_string_literal: true

require_relative 'invoice_splitter_v1_document'

module Mindee
  module Product
    # Invoice Splitter prediction.
    class InvoiceSplitterV1 < InvoiceSplitterV1Document
      @endpoint_name = 'invoice_splitter'
      @endpoint_version = '1'

      class << self
        attr_reader :endpoint_name, :endpoint_version
      end
    end
  end
end
