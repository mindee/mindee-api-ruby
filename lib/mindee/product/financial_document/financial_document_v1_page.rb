# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'financial_document_v1_document'

module Mindee
  module Product
    # Financial Document V1 prediction page.
    class FinancialDocumentV1Page < FinancialDocumentV1Document
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