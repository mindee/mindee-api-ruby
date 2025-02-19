# frozen_string_literal: true

require_relative 'payslip_v3_pay_period'
require_relative 'payslip_v3_employee'
require_relative 'payslip_v3_employer'
require_relative 'payslip_v3_bank_account_detail'
require_relative 'payslip_v3_employment'
require_relative 'payslip_v3_salary_detail'
require_relative 'payslip_v3_pay_detail'
require_relative 'payslip_v3_paid_time_off'

module Mindee
  module Product
    module FR
      module Payslip
        # Detailed information about the earnings.
        class PayslipV3SalaryDetails < Array
          # Entries.
          # @return [Array<PayslipV3SalaryDetail>]
          attr_reader :entries

          # @param prediction [Array]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            entries = prediction.map do |entry|
              Payslip::PayslipV3SalaryDetail.new(entry, page_id)
            end
            super(entries)
          end

          # Creates a line of rST table-compliant string separators.
          # @param char [String] Character to use as a separator.
          # @return [String]
          def self.line_items_separator(char)
            out_str = String.new
            out_str << "+#{char * 14}"
            out_str << "+#{char * 11}"
            out_str << "+#{char * 38}"
            out_str << "+#{char * 8}"
            out_str << "+#{char * 11}"
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
            out_str << ' | Amount      '
            out_str << ' | Base     '
            out_str << ' | Description                         '
            out_str << ' | Number'
            out_str << ' | Rate     '
            out_str << (" |\n#{self.class.line_items_separator('=')}")
            out_str + lines
          end
        end
      end
    end
  end
end
