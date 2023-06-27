# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'bank_account_details_v1_document'
require_relative 'bank_account_details_v1_page'

module Mindee
  module Product
    module FR
      module BankAccountDetails
        # Bank Account Details v1 prediction inference.
        class BankAccountDetailsV1 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'bank_account_details'
          @endpoint_version = '1'

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = BankAccountDetailsV1Document.new(prediction['prediction'], nil)
            @pages = []
            prediction['pages'].each do |page|
              @pages.push(BankAccountDetailsV1Page.new(page))
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
