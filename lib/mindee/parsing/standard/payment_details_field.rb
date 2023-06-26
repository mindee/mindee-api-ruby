# frozen_string_literal: true

require_relative 'base_field'

module Mindee
  module Parsing
    module Standard
      # Represents payment details for invoices and receipts
      class PaymentDetails < Field
        # @return [String, nil]
        attr_reader :account_number
        # @return [String, nil]
        attr_reader :iban
        # @return [String, nil]
        attr_reader :routing_number
        # @return [String, nil]
        attr_reader :swift

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        # @param reconstructed [Boolean]
        def initialize(prediction, page_id, reconstructed: false)
          super
          @account_number = prediction['account_number']
          @iban = prediction['iban']
          @routing_number = prediction['routing_number']
          @swift = prediction['swift']
        end

        # @return [String]
        def to_s
          out_str = String.new
          out_str << "#{@account_number}; " if @account_number
          out_str << "#{@iban}; " if @iban
          out_str << "#{@routing_number}; " if @routing_number
          out_str << "#{@swift}; " if @swift
          out_str.strip
        end
      end
    end
  end
end
