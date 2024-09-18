# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module BankAccountDetails
        # Full extraction of BBAN, including: branch code, bank code, account and key.
        class BankAccountDetailsV2Bban < Mindee::Parsing::Standard::FeatureField
          include Mindee::Parsing::Standard
          # The BBAN bank code outputted as a string.
          # @return [String]
          attr_reader :bban_bank_code
          # The BBAN branch code outputted as a string.
          # @return [String]
          attr_reader :bban_branch_code
          # The BBAN key outputted as a string.
          # @return [String]
          attr_reader :bban_key
          # The BBAN Account number outputted as a string.
          # @return [String]
          attr_reader :bban_number

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super(prediction, page_id)
            @bban_bank_code = prediction['bban_bank_code']
            @bban_branch_code = prediction['bban_branch_code']
            @bban_key = prediction['bban_key']
            @bban_number = prediction['bban_number']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:bban_bank_code] = format_for_display(@bban_bank_code)
            printable[:bban_branch_code] = format_for_display(@bban_branch_code)
            printable[:bban_key] = format_for_display(@bban_key)
            printable[:bban_number] = format_for_display(@bban_number)
            printable
          end

          # @return [Hash]
          def table_printable_values
            printable = {}
            printable[:bban_bank_code] = format_for_display(@bban_bank_code, nil)
            printable[:bban_branch_code] = format_for_display(@bban_branch_code, nil)
            printable[:bban_key] = format_for_display(@bban_key, nil)
            printable[:bban_number] = format_for_display(@bban_number, nil)
            printable
          end

          # @return [String]
          def to_table_line
            printable = table_printable_values
            out_str = String.new
            out_str << format('| %- 10s', printable[:bban_bank_code])
            out_str << format('| %- 12s', printable[:bban_branch_code])
            out_str << format('| %- 4s', printable[:bban_key])
            out_str << format('| %- 15s', printable[:bban_number])
            out_str << '|'
          end

          # @return [String]
          def to_s
            printable = printable_values
            out_str = String.new
            out_str << "\n  :Bank Code: #{printable[:bban_bank_code]}"
            out_str << "\n  :Branch Code: #{printable[:bban_branch_code]}"
            out_str << "\n  :Key: #{printable[:bban_key]}"
            out_str << "\n  :Account Number: #{printable[:bban_number]}"
            out_str
          end
        end
      end
    end
  end
end
