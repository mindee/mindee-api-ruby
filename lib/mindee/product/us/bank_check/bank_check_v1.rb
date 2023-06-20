# frozen_string_literal: true

require_relative 'bank_check_v1_document'

module Mindee
  module Product
    module US
      # License plate prediction.
      class BankCheckV1 < BankCheckV1Document
        @endpoint_name = 'bank_check'
        @endpoint_version = '1'

        class << self
          attr_reader :endpoint_name, :endpoint_version
        end
      end
    end
  end
end
