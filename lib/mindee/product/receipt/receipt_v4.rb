# frozen_string_literal: true

require_relative 'receipt_v4_document'

module Mindee
  module Product
    # Receipt document.
    class ReceiptV4 < ReceiptV4Document
      @endpoint_name = 'expense_receipts'
      @endpoint_version = '4'

      class << self
        attr_reader :endpoint_name, :endpoint_version
      end
    end
  end
end
