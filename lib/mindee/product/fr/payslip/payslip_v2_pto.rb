# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module Payslip
        # Information about paid time off.
        class PayslipV2Pto < Mindee::Parsing::Standard::FeatureField
          include Mindee::Parsing::Standard
          # The amount of paid time off accrued in this period.
          # @return [Float]
          attr_reader :accrued_this_period
          # The balance of paid time off at the end of the period.
          # @return [Float]
          attr_reader :balance_end_of_period
          # The amount of paid time off used in this period.
          # @return [Float]
          attr_reader :used_this_period

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super
            @accrued_this_period = prediction['accrued_this_period']
            @balance_end_of_period = prediction['balance_end_of_period']
            @used_this_period = prediction['used_this_period']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:accrued_this_period] =
              @accrued_this_period.nil? ? '' : BaseField.float_to_string(@accrued_this_period)
            printable[:balance_end_of_period] =
              @balance_end_of_period.nil? ? '' : BaseField.float_to_string(@balance_end_of_period)
            printable[:used_this_period] = @used_this_period.nil? ? '' : BaseField.float_to_string(@used_this_period)
            printable
          end

          # @return [String]
          def to_s
            printable = printable_values
            out_str = String.new
            out_str << "\n  :Accrued This Period: #{printable[:accrued_this_period]}"
            out_str << "\n  :Balance End of Period: #{printable[:balance_end_of_period]}"
            out_str << "\n  :Used This Period: #{printable[:used_this_period]}"
            out_str
          end
        end
      end
    end
  end
end
