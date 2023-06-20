# frozen_string_literal: true

require_relative 'receipt_v5_document'

module Mindee
  module Product
    # Expense Receipt v5 prediction results.
    class ReceiptV5 < ReceiptV5Document
      @endpoint_name = 'expense_receipts'
      @endpoint_version = '5'

      class << self
        attr_reader :endpoint_name, :endpoint_version
      end
    end
  end
end
