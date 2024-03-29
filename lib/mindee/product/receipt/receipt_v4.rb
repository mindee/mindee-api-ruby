# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'receipt_v4_document'
require_relative 'receipt_v4_page'

module Mindee
  module Product
    module Receipt
      # Expense Receipt V4 prediction inference.
      class ReceiptV4 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'expense_receipts'
        @endpoint_version = '4'

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = ReceiptV4Document.new(prediction['prediction'], nil)
          @pages = []
          prediction['pages'].each do |page|
            @pages.push(ReceiptV4Page.new(page))
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
