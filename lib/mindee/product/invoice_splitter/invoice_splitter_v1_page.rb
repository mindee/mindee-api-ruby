# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'invoice_splitter_v1_document'

module Mindee
  module Product
    module InvoiceSplitter
      # Invoice Splitter V1 page.
      class InvoiceSplitterV1Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = InvoiceSplitterV1PagePrediction.new(
            prediction['prediction'],
            prediction['id']
          )
        end
      end

      # Invoice Splitter V1 page prediction.
      class InvoiceSplitterV1PagePrediction < InvoiceSplitterV1Document
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
