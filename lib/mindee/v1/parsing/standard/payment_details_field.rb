# frozen_string_literal: true

require_relative 'base_field'

module Mindee
  module V1
    module Parsing
      module Standard
        # Represents payment details for invoices and receipts
        class PaymentDetailsField < BaseField
          # The account number.
          # @return [String, nil]
          attr_reader :account_number
          # The full IBAN.
          # @return [String, nil]
          attr_reader :iban
          # The routing number.
          # @return [String, nil]
          attr_reader :routing_number
          # The SWIFT value.
          # @return [String, nil]
          attr_reader :swift
          # The UK and Irish sort code (6 digits).
          # @return [String, nil]
          attr_reader :sort_code

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          # @param reconstructed [bool]
          def initialize(prediction, page_id, reconstructed: false)
            super
            @account_number = prediction['account_number']
            @iban = prediction['iban']
            @routing_number = prediction['routing_number']
            @swift = prediction['swift']
            @sort_code = prediction['sort_code']
          end

          # @return [String]
          def to_s
            out_str = String.new
            out_str << "#{@account_number}; " if @account_number
            out_str << "#{@iban}; " if @iban
            out_str << "#{@routing_number}; " if @routing_number
            out_str << "#{@swift}; " if @swift
            out_str << "#{@sort_code}; " if @sort_code
            out_str.strip
          end
        end
      end
    end
  end
end
