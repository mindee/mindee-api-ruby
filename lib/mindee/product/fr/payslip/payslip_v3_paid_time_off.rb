# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module Payslip
        # Information about paid time off.
        class PayslipV3PaidTimeOff < Mindee::Parsing::Standard::FeatureField
          include Mindee::Parsing::Standard
          # The amount of paid time off accrued in the period.
          # @return [Float]
          attr_reader :accrued
          # The paid time off period.
          # @return [String]
          attr_reader :period
          # The type of paid time off.
          # @return [String]
          attr_reader :pto_type
          # The remaining amount of paid time off at the end of the period.
          # @return [Float]
          attr_reader :remaining
          # The amount of paid time off used in the period.
          # @return [Float]
          attr_reader :used

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super(prediction, page_id)
            @accrued = prediction['accrued']
            @period = prediction['period']
            @pto_type = prediction['pto_type']
            @remaining = prediction['remaining']
            @used = prediction['used']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:accrued] = @accrued.nil? ? '' : Field.float_to_string(@accrued)
            printable[:period] = format_for_display(@period)
            printable[:pto_type] = format_for_display(@pto_type)
            printable[:remaining] = @remaining.nil? ? '' : Field.float_to_string(@remaining)
            printable[:used] = @used.nil? ? '' : Field.float_to_string(@used)
            printable
          end

          # @return [Hash]
          def table_printable_values
            printable = {}
            printable[:accrued] = @accrued.nil? ? '' : Field.float_to_string(@accrued)
            printable[:period] = format_for_display(@period, 6)
            printable[:pto_type] = format_for_display(@pto_type, 11)
            printable[:remaining] = @remaining.nil? ? '' : Field.float_to_string(@remaining)
            printable[:used] = @used.nil? ? '' : Field.float_to_string(@used)
            printable
          end

          # @return [String]
          def to_table_line
            printable = table_printable_values
            out_str = String.new
            out_str << format('| %- 10s', printable[:accrued])
            out_str << format('| %- 7s', printable[:period])
            out_str << format('| %- 12s', printable[:pto_type])
            out_str << format('| %- 10s', printable[:remaining])
            out_str << format('| %- 10s', printable[:used])
            out_str << '|'
          end

          # @return [String]
          def to_s
            printable = printable_values
            out_str = String.new
            out_str << "\n  :Accrued: #{printable[:accrued]}"
            out_str << "\n  :Period: #{printable[:period]}"
            out_str << "\n  :Type: #{printable[:pto_type]}"
            out_str << "\n  :Remaining: #{printable[:remaining]}"
            out_str << "\n  :Used: #{printable[:used]}"
            out_str
          end
        end
      end
    end
  end
end
