# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'receipt_v5_document'
require_relative 'receipt_v5_page'

module Mindee
  module Product
    # Receipt module.
    module Receipt
      # Receipt API version 5 inference prediction.
      class ReceiptV5 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'expense_receipts'
        @endpoint_version = '5'

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = ReceiptV5Document.new(prediction['prediction'], nil)
          @pages = []
          prediction['pages'].each do |page|
            if page.key?('prediction') && !page['prediction'].nil? && !page['prediction'].empty?
              @pages.push(ReceiptV5Page.new(page))
            end
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
