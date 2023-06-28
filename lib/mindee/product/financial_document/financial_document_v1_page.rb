# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'financial_document_v1_document'

module Mindee
  module Product
    module FinancialDocument
      # Financial Document V1 page.
      class FinancialDocumentV1Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super(prediction)
          @prediction = FinancialDocumentV1PagePrediction.new(
            prediction['prediction'],
            prediction['id']
          )
        end
      end

      # Financial Document V1 page prediction.
      class FinancialDocumentV1PagePrediction < FinancialDocumentV1Document
        # @return [String]
        def to_s
          out_str = String.new
          out_str << "\n#{super}"
          out_str
        end
      end
    end
  end
end
