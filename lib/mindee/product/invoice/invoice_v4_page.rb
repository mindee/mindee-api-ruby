# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'invoice_v4_document'

module Mindee
  module Product
    module Invoice
      class InvoiceV4Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super(prediction)
          @prediction = InvoiceV4PagePrediction.new(
            prediction['prediction'],
            prediction['id']
          ) 
        end
      end

      # Invoice V4 page prediction.
      class InvoiceV4PagePrediction < InvoiceV4Document
        include Mindee::Parsing::Standard

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super(prediction, page_id)
        end

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
