# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module Payslip
        # Detailed information about the earnings.
        class PayslipV2SalaryDetail < Mindee::Parsing::Standard::FeatureField
          include Mindee::Parsing::Standard
          # The amount of the earnings.
          # @return [Float]
          attr_reader :amount
          # The base value of the earnings.
          # @return [Float]
          attr_reader :base
          # The description of the earnings.
          # @return [String]
          attr_reader :description
          # The rate of the earnings.
          # @return [Float]
          attr_reader :rate

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super
            @amount = prediction['amount']
            @base = prediction['base']
            @description = prediction['description']
            @rate = prediction['rate']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:amount] = @amount.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@amount)
            printable[:base] = @base.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@base)
            printable[:description] = format_for_display(@description)
            printable[:rate] = @rate.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@rate)
            printable
          end

          # @return [Hash]
          def table_printable_values
            printable = {}
            printable[:amount] = @amount.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@amount)
            printable[:base] = @base.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@base)
            printable[:description] = format_for_display(@description, 36)
            printable[:rate] = @rate.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@rate)
            printable
          end

          # @return [String]
          def to_table_line
            printable = table_printable_values
            out_str = String.new
            out_str << format('| %- 13s', printable[:amount])
            out_str << format('| %- 10s', printable[:base])
            out_str << format('| %- 37s', printable[:description])
            out_str << format('| %- 10s', printable[:rate])
            out_str << '|'
          end

          # @return [String]
          def to_s
            printable = printable_values
            out_str = String.new
            out_str << "\n  :Amount: #{printable[:amount]}"
            out_str << "\n  :Base: #{printable[:base]}"
            out_str << "\n  :Description: #{printable[:description]}"
            out_str << "\n  :Rate: #{printable[:rate]}"
            out_str
          end
        end
      end
    end
  end
end
