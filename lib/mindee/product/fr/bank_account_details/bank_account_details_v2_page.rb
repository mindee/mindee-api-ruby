# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'bank_account_details_v2_document'

module Mindee
  module Product
    module FR
      module BankAccountDetails
        # Bank Account Details API version 2.0 page data.
        class BankAccountDetailsV2Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = BankAccountDetailsV2PagePrediction.new(
              prediction['prediction'],
              prediction['id']
            )
          end
        end

        # Bank Account Details V2 page prediction.
        class BankAccountDetailsV2PagePrediction < BankAccountDetailsV2Document
          # @return [String]
          def to_s
            out_str = String.new
            out_str << "\n#{super}"
            out_str
          end
        end
      end
    end
  end
end
