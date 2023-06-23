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

          def initialize(http_response)
            super
            @prediction = BankAccountDetailsV1Document.new(http_response['prediction'], nil)
            @pages = []
            http_response['pages'].each do |page|
              @pages.push(BankAccountDetailsV1Page.new(page))
            end
          end

          class << self
            attr_reader :endpoint_name, :endpoint_version
          end
        end
      end
    end
  end
end
