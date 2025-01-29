# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'bank_account_details_v2_document'
require_relative 'bank_account_details_v2_page'

module Mindee
  module Product
    module FR
      # Bank Account Details module.
      module BankAccountDetails
        # Bank Account Details API version 2 inference prediction.
        class BankAccountDetailsV2 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'bank_account_details'
          @endpoint_version = '2'

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = BankAccountDetailsV2Document.new(prediction['prediction'], nil)
            @pages = []
            prediction['pages'].each do |page|
              @pages.push(BankAccountDetailsV2Page.new(page))
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
end
