# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'receipt_v5_document'
require_relative 'receipt_v5_page'

module Mindee
  module Product
    module Receipt
      # Expense Receipt V5 prediction infrence.
      class ReceiptV5 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'expense_receipts'
        @endpoint_version = '5'

        def initialize(http_response)
          super
          @prediction = ReceiptV5Document.new(http_response['prediction'], nil)
          @pages = []
          http_response['pages'].each do |page|
            @pages.push(ReceiptV5Page.new(page))
          end
        end

        class << self
          attr_reader :endpoint_name, :endpoint_version
        end
      end
    end
  end
end
