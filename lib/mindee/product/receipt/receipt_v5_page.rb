# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'receipt_v5_document'

module Mindee
  module Product
    module Receipt
      # Expense Receipt V5 page.
      class ReceiptV5Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super(prediction)
          @prediction = ReceiptV5PagePrediction.new(
            prediction['prediction'],
            prediction['id']
          )
        end
      end

      # Expense Receipt V5 page prediction.
      class ReceiptV5PagePrediction < ReceiptV5Document
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
