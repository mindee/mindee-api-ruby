# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'bank_account_details_v2_bban'

module Mindee
  module Product
    module FR
      module BankAccountDetails
        # Bank Account Details API version 2.0 document data.
        class BankAccountDetailsV2Document < Mindee::Parsing::Common::Prediction
          include Mindee::Parsing::Standard
          # Full extraction of the account holders names.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :account_holders_names
          # Full extraction of BBAN, including: branch code, bank code, account and key.
          # @return [Mindee::Product::FR::BankAccountDetails::BankAccountDetailsV2Bban]
          attr_reader :bban
          # Full extraction of the IBAN number.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :iban
          # Full extraction of the SWIFT code.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :swift_code

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super(prediction, page_id)
            @account_holders_names = Parsing::Standard::StringField.new(prediction['account_holders_names'], page_id)
            @bban = Product::FR::BankAccountDetails::BankAccountDetailsV2Bban.new(prediction['bban'], page_id)
            @iban = Parsing::Standard::StringField.new(prediction['iban'], page_id)
            @swift_code = Parsing::Standard::StringField.new(prediction['swift_code'], page_id)
          end

          # @return [String]
          def to_s
            bban = @bban.to_s
            out_str = String.new
            out_str << "\n:Account Holder's Names: #{@account_holders_names}".rstrip
            out_str << "\n:Basic Bank Account Number:"
            out_str << bban
            out_str << "\n:IBAN: #{@iban}".rstrip
            out_str << "\n:SWIFT Code: #{@swift_code}".rstrip
            out_str[1..].to_s
          end
        end
      end
    end
  end
end
