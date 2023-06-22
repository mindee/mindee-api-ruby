# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'receipt_v4_document'
require_relative 'receipt_v4_page'

include Mindee::Parsing::Common

module Mindee
  module Product
    # Expense Receipt V4 prediction inference.
    class ReceiptV4 < Inference
      @endpoint_name = 'expense_receipts'
      @endpoint_version = '4'

      def initialize(http_response)
        super
        @prediction = ReceiptV4Document.new(http_response['prediction'], nil)
        @pages = []
        http_response['pages'].each do |page|
          @pages.push(ReceiptV4Page.new(page))
        end
      end

      class << self
        attr_reader :endpoint_name, :endpoint_version
      end
    end
  end
end
