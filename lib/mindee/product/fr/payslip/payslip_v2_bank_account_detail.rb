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
            super(prediction, page_id)
            @bank_name = prediction['bank_name']
            @iban = prediction['iban']
            @swift = prediction['swift']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:bank_name] = format_for_display(@bank_name, nil)
            printable[:iban] = format_for_display(@iban, nil)
            printable[:swift] = format_for_display(@swift, nil)
            printable
          end

          # @return [String]
          def to_table_line
            printable = printable_values
            out_str = String.new
            out_str << format('| %- 10s', printable[:bank_name])
            out_str << format('| %- 5s', printable[:iban])
            out_str << format('| %- 6s', printable[:swift])
            out_str << '|'
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
