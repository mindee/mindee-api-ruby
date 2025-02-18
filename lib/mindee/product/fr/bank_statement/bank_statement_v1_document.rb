# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'bank_statement_v1_transaction'

module Mindee
  module Product
    module FR
      module BankStatement
        # Bank Statement API version 1.1 document data.
        class BankStatementV1Document < Mindee::Parsing::Common::Prediction
          include Mindee::Parsing::Standard
          # The unique identifier for a customer's account in the bank's system.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :account_number
          # The physical location of the bank where the statement was issued.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :bank_address
          # The name of the bank that issued the statement.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :bank_name
          # The address of the client associated with the bank statement.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :client_address
          # The name of the client who owns the bank statement.
          # @return [Mindee::Parsing::Standard::StringField]
          attr_reader :client_name
          # The final amount of money in the account at the end of the statement period.
          # @return [Mindee::Parsing::Standard::AmountField]
          attr_reader :closing_balance
          # The initial amount of money in an account at the start of the period.
          # @return [Mindee::Parsing::Standard::AmountField]
          attr_reader :opening_balance
          # The date on which the bank statement was generated.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :statement_date
          # The date when the statement period ends.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :statement_end_date
          # The date when the bank statement period begins.
          # @return [Mindee::Parsing::Standard::DateField]
          attr_reader :statement_start_date
          # The total amount of money deposited into the account.
          # @return [Mindee::Parsing::Standard::AmountField]
          attr_reader :total_credits
          # The total amount of money debited from the account.
          # @return [Mindee::Parsing::Standard::AmountField]
          attr_reader :total_debits
          # The list of values that represent the financial transactions recorded in a bank statement.
          # @return [Array<Mindee::Product::FR::BankStatement::BankStatementV1Transaction>]
          attr_reader :transactions

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super
            @account_number = Parsing::Standard::StringField.new(
              prediction['account_number'],
              page_id
            )
            @bank_address = Parsing::Standard::StringField.new(
              prediction['bank_address'],
              page_id
            )
            @bank_name = Parsing::Standard::StringField.new(
              prediction['bank_name'],
              page_id
            )
            @client_address = Parsing::Standard::StringField.new(
              prediction['client_address'],
              page_id
            )
            @client_name = Parsing::Standard::StringField.new(
              prediction['client_name'],
              page_id
            )
            @closing_balance = Parsing::Standard::AmountField.new(
              prediction['closing_balance'],
              page_id
            )
            @opening_balance = Parsing::Standard::AmountField.new(
              prediction['opening_balance'],
              page_id
            )
            @statement_date = Parsing::Standard::DateField.new(
              prediction['statement_date'],
              page_id
            )
            @statement_end_date = Parsing::Standard::DateField.new(
              prediction['statement_end_date'],
              page_id
            )
            @statement_start_date = Parsing::Standard::DateField.new(
              prediction['statement_start_date'],
              page_id
            )
            @total_credits = Parsing::Standard::AmountField.new(
              prediction['total_credits'],
              page_id
            )
            @total_debits = Parsing::Standard::AmountField.new(
              prediction['total_debits'],
              page_id
            )
            @transactions = [] # : Array[BankStatement::BankStatementV1Transaction]
            prediction['transactions'].each do |item|
              @transactions.push(BankStatement::BankStatementV1Transaction.new(item, page_id))
            end
          end

          # @return [String]
          def to_s
            transactions = transactions_to_s
            out_str = String.new
            out_str << "\n:Account Number: #{@account_number}".rstrip
            out_str << "\n:Bank Name: #{@bank_name}".rstrip
            out_str << "\n:Bank Address: #{@bank_address}".rstrip
            out_str << "\n:Client Name: #{@client_name}".rstrip
            out_str << "\n:Client Address: #{@client_address}".rstrip
            out_str << "\n:Statement Date: #{@statement_date}".rstrip
            out_str << "\n:Statement Start Date: #{@statement_start_date}".rstrip
            out_str << "\n:Statement End Date: #{@statement_end_date}".rstrip
            out_str << "\n:Opening Balance: #{@opening_balance}".rstrip
            out_str << "\n:Closing Balance: #{@closing_balance}".rstrip
            out_str << "\n:Transactions:"
            out_str << transactions
            out_str << "\n:Total Debits: #{@total_debits}".rstrip
            out_str << "\n:Total Credits: #{@total_credits}".rstrip
            out_str[1..].to_s
          end

          private

          # @param char [String]
          # @return [String]
          def transactions_separator(char)
            out_str = String.new
            out_str << '  '
            out_str << "+#{char * 11}"
            out_str << "+#{char * 12}"
            out_str << "+#{char * 38}"
            out_str << '+'
            out_str
          end

          # @return [String]
          def transactions_to_s
            return '' if @transactions.empty?

            line_items = @transactions.map(&:to_table_line).join("\n#{transactions_separator('-')}\n  ")
            out_str = String.new
            out_str << "\n#{transactions_separator('-')}"
            out_str << "\n  |"
            out_str << ' Amount    |'
            out_str << ' Date       |'
            out_str << ' Description                          |'
            out_str << "\n#{transactions_separator('=')}"
            out_str << "\n  #{line_items}"
            out_str << "\n#{transactions_separator('-')}"
            out_str
          end
        end
      end
    end
  end
end
