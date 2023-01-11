# frozen_string_literal: true

require_relative '../../common_fields'
require_relative '../../base'

module Mindee
  module Prediction
    module FR
      # French bank account information (RIB)
      class BankAccountDetailsV1 < Prediction
        # The account's IBAN.
        # @return [Mindee::TextField]
        attr_reader :iban
        # The account holder's name.
        # @return [Mindee::TextField]
        attr_reader :account_holder_name
        # The bank's SWIFT code.
        # @return [Mindee::TextField]
        attr_reader :swift

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @iban = TextField.new(prediction['iban'], page_id)
          @account_holder_name = TextField.new(prediction['account_holder_name'], page_id)
          @swift = TextField.new(prediction['swift'], page_id)
        end

        def to_s
          out_str = String.new
          out_str << "\n:IBAN: #{@iban}".rstrip
          out_str << "\n:Account holder name: #{@account_holder_name}".rstrip
          out_str << "\n:SWIFT: #{@swift}".rstrip
          out_str[1..].to_s
        end
      end
    end
  end
end
