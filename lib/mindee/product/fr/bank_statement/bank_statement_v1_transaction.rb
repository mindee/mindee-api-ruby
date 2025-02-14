# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module BankStatement
        # The list of values that represent the financial transactions recorded in a bank statement.
        class BankStatementV1Transaction < Mindee::Parsing::Standard::FeatureField
          include Mindee::Parsing::Standard
          # The monetary amount of the transaction.
          # @return [Float]
          attr_reader :amount
          # The date on which the transaction occurred.
          # @return [String]
          attr_reader :date
          # The additional information about the transaction.
          # @return [String]
          attr_reader :description

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super
            @amount = prediction['amount']
            @date = prediction['date']
            @description = prediction['description']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:amount] = @amount.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@amount)
            printable[:date] = format_for_display(@date)
            printable[:description] = format_for_display(@description)
            printable
          end

          # @return [Hash]
          def table_printable_values
            printable = {}
            printable[:amount] = @amount.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@amount)
            printable[:date] = format_for_display(@date, nil)
            printable[:description] = format_for_display(@description, nil)
            printable
          end

          # @return [String]
          def to_table_line
            printable = table_printable_values
            out_str = String.new
            out_str << format('| %- 7s', printable[:amount])
            out_str << format('| %- 5s', printable[:date])
            out_str << format('| %- 12s', printable[:description])
            out_str << '|'
          end

          # @return [String]
          def to_s
            printable = printable_values
            out_str = String.new
            out_str << "\n  :Amount: #{printable[:amount]}"
            out_str << "\n  :Date: #{printable[:date]}"
            out_str << "\n  :Description: #{printable[:description]}"
            out_str
          end
        end
      end
    end
  end
end
