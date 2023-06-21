# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'financial_document_v1_document'
require_relative 'financial_document_v1_page'

module Mindee
  module Product
    # Financial Document v1 prediction results.
    class FinancialDocumentV1 < Inference
      @endpoint_name = 'financial_document'
      @endpoint_version = '1'

      def initialize(http_response)
        super
        @prediction = FinancialDocumentV1Document.new(http_response['prediction'], nil)
        @pages = []
        http_response['pages'].each do |page|
          @pages.push(FinancialDocumentV1Page.new(page))
        end
      end

      class << self
        attr_reader :endpoint_name, :endpoint_version
      end
    end
  end
end
