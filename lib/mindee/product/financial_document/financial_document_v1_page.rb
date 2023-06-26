# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'financial_document_v1_document'

module Mindee
  module Product
    module FinancialDocument
      # Financial Document V1 page prediction.
      class FinancialDocumentV1Page < FinancialDocumentV1Document
        include Mindee::Parsing::Common
        # @return [Integer]
        attr_reader :page_id
        # @return [Mindee::Parsing::Common::Orientation]
        attr_reader :orientation

        def initialize(http_response)
          @page_id = http_response['id']
          @orientation = Orientation.new(http_response['orientation'], @page_id)
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
end
