# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module Payslip
        # Information about the employee's bank account.
        class PayslipV2BankAccountDetail < Mindee::Parsing::Standard::FeatureField
          include Mindee::Parsing::Standard
          # The name of the bank.
          # @return [String]
          attr_reader :bank_name
          # The IBAN of the bank account.
          # @return [String]
          attr_reader :iban
          # The SWIFT code of the bank.
          # @return [String]
          attr_reader :swift

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super
            @bank_name = prediction['bank_name']
            @iban = prediction['iban']
            @swift = prediction['swift']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:bank_name] = format_for_display(@bank_name)
            printable[:iban] = format_for_display(@iban)
            printable[:swift] = format_for_display(@swift)
            printable
          end

          # @return [String]
          def to_s
            printable = printable_values
            out_str = String.new
            out_str << "\n  :Bank Name: #{printable[:bank_name]}"
            out_str << "\n  :IBAN: #{printable[:iban]}"
            out_str << "\n  :SWIFT: #{printable[:swift]}"
            out_str
          end
        end
      end
    end
  end
end
