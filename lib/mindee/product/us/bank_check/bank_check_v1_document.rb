# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module US
      module BankCheck
        # Bank Check API version 1.1 document data.
        class BankCheckV1Document < Mindee::Parsing::Common::Prediction
          include Mindee::Parsing::Standard
          # The check payer's account number.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :account_number
          # The amount of the check.
          # @return [Mindee::Parsing::Standard::AmountField]
          attr_reader :amount
          # The issuer's check number.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :check_number
          # The date the check was issued.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :date
          # List of the check's payees (recipients).
          # @return [Array<Mindee::Parsing::Standard::StringField>]
          attr_reader :payees
          # The check issuer's routing number.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :routing_number

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super(prediction)
            @account_number = StringField.new(prediction['account_number'], page_id)
            @amount = AmountField.new(prediction['amount'], page_id)
            @check_number = StringField.new(prediction['check_number'], page_id)
            @date = DateField.new(prediction['date'], page_id)
            @payees = []
            prediction['payees'].each do |item|
              @payees.push(Parsing::Standard::StringField.new(item, page_id))
            end
            @routing_number = StringField.new(prediction['routing_number'], page_id)
          end

          # @return [String]
          def to_s
            payees = @payees.join("\n #{' ' * 8}")
            out_str = String.new
            out_str << "\n:Check Issue Date: #{@date}".rstrip
            out_str << "\n:Amount: #{@amount}".rstrip
            out_str << "\n:Payees: #{payees}".rstrip
            out_str << "\n:Routing Number: #{@routing_number}".rstrip
            out_str << "\n:Account Number: #{@account_number}".rstrip
            out_str << "\n:Check Number: #{@check_number}".rstrip
            out_str[1..].to_s
          end
        end
      end
    end
  end
end
