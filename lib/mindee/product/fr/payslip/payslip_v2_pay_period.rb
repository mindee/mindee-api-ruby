# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module Payslip
        # Information about the pay period.
        class PayslipV2PayPeriod < Mindee::Parsing::Standard::FeatureField
          include Mindee::Parsing::Standard
          # The end date of the pay period.
          # @return [String]
          attr_reader :end_date
          # The month of the pay period.
          # @return [String]
          attr_reader :month
          # The date of payment for the pay period.
          # @return [String]
          attr_reader :payment_date
          # The start date of the pay period.
          # @return [String]
          attr_reader :start_date
          # The year of the pay period.
          # @return [String]
          attr_reader :year

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super(prediction, page_id)
            @end_date = prediction['end_date']
            @month = prediction['month']
            @payment_date = prediction['payment_date']
            @start_date = prediction['start_date']
            @year = prediction['year']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:end_date] = format_for_display(@end_date)
            printable[:month] = format_for_display(@month)
            printable[:payment_date] = format_for_display(@payment_date)
            printable[:start_date] = format_for_display(@start_date)
            printable[:year] = format_for_display(@year)
            printable
          end

          # @return [String]
          def to_s
            printable = printable_values
            out_str = String.new
            out_str << "\n  :End Date: #{printable[:end_date]}"
            out_str << "\n  :Month: #{printable[:month]}"
            out_str << "\n  :Payment Date: #{printable[:payment_date]}"
            out_str << "\n  :Start Date: #{printable[:start_date]}"
            out_str << "\n  :Year: #{printable[:year]}"
            out_str
          end
        end
      end
    end
  end
end
