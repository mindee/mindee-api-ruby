# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'invoice_v4_document'

module Mindee
  module Product
    module Invoice
      # Invoice API version 4.7 page data.
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
