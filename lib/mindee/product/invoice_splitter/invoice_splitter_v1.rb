# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'invoice_splitter_v1_document'
require_relative 'invoice_splitter_v1_page'

module Mindee
  module Product
    # Invoice Splitter prediction.
    class InvoiceSplitterV1 < Inference
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
        attr_reader :endpoint_name, :endpoint_version
      end
    end
  end
end
