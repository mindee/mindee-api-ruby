# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'invoice_v4_document'

module Mindee
  module Product
    # Invoice V4 prediction page.
    class InvoiceV4Page < InvoiceV4Document
      # @return [Integer]
      attr_reader :page_id
      # @return [Mindee::Orientation]
      attr_reader :orientation

      def initialize(http_response)
        @page_id = http_response['id']
        @orientation = Mindee::Parsing::Common::Orientation.new(http_response['orientation'], @page_id)
        super(http_response['prediction'], @page_id)
      end

      def to_s
        out_str = String.new
        title = "Page #{@page_id}"
        out_str << "#{title}\n"
        out_str << ('-' * title.size)
        out_str << "\n#{super}"
        out_str
      end
    end
  end
end