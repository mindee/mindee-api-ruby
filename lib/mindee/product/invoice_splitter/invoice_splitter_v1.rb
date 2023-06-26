# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'invoice_splitter_v1_document'
require_relative 'invoice_splitter_v1_page'

module Mindee
  module Product
    module InvoiceSplitter
      # Invoice Splitter V1 prediction inference.
      class InvoiceSplitterV1 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'invoice_splitter'
        @endpoint_version = '1'

        def initialize(http_response)
          super
          @prediction = InvoiceSplitterV1Document.new(http_response['prediction'], nil)
          @pages = []
          http_response['pages'].each do |page|
            @pages.push(InvoiceSplitterV1Page.new(page))
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
