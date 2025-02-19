# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'bank_account_details_v1_document'

module Mindee
  module Product
    module FR
      module BankAccountDetails
        # Bank Account Details API version 1.0 page data.
        class BankAccountDetailsV1Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = if prediction['prediction'].empty?
                            nil
                          else
                            BankAccountDetailsV1PagePrediction.new(
                              prediction['prediction'],
                              prediction['id']
                            )
                          end
          end
        end

        # Bank Account Details V1 page prediction.
        class BankAccountDetailsV1PagePrediction < BankAccountDetailsV1Document
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
