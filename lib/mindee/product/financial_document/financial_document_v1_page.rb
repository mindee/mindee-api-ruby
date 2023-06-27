# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'financial_document_v1_document'

module Mindee
  module Product
    module FinancialDocument
      # Financial Document V1 page prediction.
      class FinancialDocumentV1Page < FinancialDocumentV1Document
        include Mindee::Parsing::Common

        # Id of the page (as given by the API).
        # @return [Integer]
        attr_reader :page_id
        # Orientation of the page.
        # @return [Mindee::Parsing::Common::Orientation]
        attr_reader :orientation

        # @param prediction [Hash]
        def initialize(prediction)
          @page_id = prediction['id']
          @orientation = Orientation.new(prediction['orientation'], @page_id)
          super(prediction['prediction'], @page_id)
        end

        # @return [String]
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
end
