# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module BankAccountDetails
        # Bank Account Details API version 1.0 document data.
        class BankAccountDetailsV1Document < Mindee::Parsing::Common::Prediction
          include Mindee::Parsing::Standard
          # The name of the account holder as seen on the document.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :account_holder_name
          # The International Bank Account Number (IBAN).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :iban
          # The bank's SWIFT Business Identifier Code (BIC).
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :swift

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super()
            @account_holder_name = StringField.new(prediction['account_holder_name'], page_id)
            @iban = StringField.new(prediction['iban'], page_id)
            @swift = StringField.new(prediction['swift'], page_id)
          end

          # @return [String]
          def to_s
            out_str = String.new
            out_str << "\n:IBAN: #{@iban}".rstrip
            out_str << "\n:Account Holder's Name: #{@account_holder_name}".rstrip
            out_str << "\n:SWIFT Code: #{@swift}".rstrip
            out_str[1..].to_s
          end
        end
      end
    end
  end
end
