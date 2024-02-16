# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'invoice_v4_document'
require_relative 'invoice_v4_page'

module Mindee
  module Product
    # Invoice module.
    module Invoice
      # Invoice V4 prediction inference.
      class InvoiceV4 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'invoices'
        @endpoint_version = '4'

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = InvoiceV4Document.new(prediction['prediction'], nil)
          @pages = []
          prediction['pages'].each do |page|
            if page.key?('prediction') && !page['prediction'].nil? && !page['prediction'].empty?
              @pages.push(InvoiceV4Page.new(page))
            end
          end
        end

        class << self
          # Name of the endpoint for this product.
          # @return [String]
          attr_reader :endpoint_name
          # Version for this product.
          # @return [String]
          attr_reader :endpoint_version
        end
      end
    end
  end
end
