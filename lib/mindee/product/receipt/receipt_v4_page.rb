# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'receipt_v4_document'

module Mindee
  module Product
    module Receipt
      # Expense Receipt V4 page.
      class ReceiptV4Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = ReceiptV4PagePrediction.new(
            prediction['prediction'],
            prediction['id']
          )
        end
      end

      # Expense Receipt V4 page prediction.
      class ReceiptV4PagePrediction < ReceiptV4Document
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
