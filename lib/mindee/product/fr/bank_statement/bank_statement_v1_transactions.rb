# frozen_string_literal: true

require_relative 'bank_statement_v1_transaction'

module Mindee
  module Product
    module FR
      module BankStatement
        # The list of values that represent the financial transactions recorded in a bank statement.
        class BankStatementV1Transactions < Array
          # Entries.
          # @return [Array<BankStatementV1Transaction>]
          attr_reader :entries

          # @param prediction [Array]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            entries = prediction.map do |entry|
              BankStatement::BankStatementV1Transaction.new(entry, page_id)
            end
            super(entries)
          end

          # Creates a line of rST table-compliant string separators.
          # @param char [String] Character to use as a separator.
          # @return [String]
          def self.line_items_separator(char)
            out_str = String.new
            out_str << "+#{char * 11}"
            out_str << "+#{char * 12}"
            out_str << "+#{char * 38}"
            out_str
          end

          # @return [String]
          def to_s
            return '' if empty?

            lines = map do |entry|
              "\n  #{entry.to_table_line}\n#{self.class.line_items_separator('-')}"
            end.join
            out_str = String.new
            out_str << ("\n#{self.class.line_items_separator('-')}\n ")
            out_str << ' | Amount   '
            out_str << ' | Date      '
            out_str << ' | Description                         '
            out_str << (" |\n#{self.class.line_items_separator('=')}")
            out_str + lines
          end
        end
      end
    end
  end
end
