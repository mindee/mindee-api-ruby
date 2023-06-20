# frozen_string_literal: true

require_relative 'financial_document_v1_document'

module Mindee
  module Product
    # Financial Document v1 prediction results.
    class FinancialDocumentV1 < FinancialDocumentV1Document
      @endpoint_name = 'financial_document'
      @endpoint_version = '1'

      class << self
        attr_reader :endpoint_name, :endpoint_version
      end
    end
  end
end
