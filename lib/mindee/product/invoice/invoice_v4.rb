# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'invoice_v4_document'
require_relative 'invoice_v4_page'

module Mindee
  module Product
    module Invoice
      # Invoice document.
      class InvoiceV4 < Mindee::Parsing::Common::Inference
        include Mindee::Parsing::Common
        @endpoint_name = 'invoices'
        @endpoint_version = '4'

        def initialize(http_response)
          super
          @prediction = InvoiceV4Document.new(http_response['prediction'], nil)
          @pages = []
          http_response['pages'].each do |page|
            @pages.push(InvoiceV4Page.new(page))
          end
        end

        class << self
          attr_reader :endpoint_name, :endpoint_version
        end
      end
    end
  end
end
