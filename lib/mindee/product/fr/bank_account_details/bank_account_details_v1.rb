# frozen_string_literal: true

require_relative 'bank_account_details_v1_document'

module Mindee
  module Product
    module FR
      # Bank Account Details v1 prediction results.
      class BankAccountDetailsV1 < BankAccountDetailsV1Document
        @endpoint_name = 'bank_account_details'
        @endpoint_version = '1'

        class << self
          attr_reader :endpoint_name, :endpoint_version
        end
      end
    end
  end
end
