# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'financial_document_v1_document'
require_relative 'financial_document_v1_page'

module Mindee
  module Product
    # Financial Document module.
    module FinancialDocument
      # Financial Document V1 prediction inference.
      class FinancialDocumentV1 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'financial_document'
        @endpoint_version = '1'

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = FinancialDocumentV1Document.new(prediction['prediction'], nil)
          @pages = []
          prediction['pages'].each do |page|
            @pages.push(FinancialDocumentV1Page.new(page))
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
