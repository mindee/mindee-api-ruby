# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'payslip_v2_employee'
require_relative 'payslip_v2_employer'
require_relative 'payslip_v2_bank_account_detail'
require_relative 'payslip_v2_employment'
require_relative 'payslip_v2_salary_detail'
require_relative 'payslip_v2_pay_detail'
require_relative 'payslip_v2_pto'
require_relative 'payslip_v2_pay_period'

module Mindee
  module Product
    module FR
      module Payslip
        # Payslip API version 2.0 document data.
        class PayslipV2Document < Mindee::Parsing::Common::Prediction
          include Mindee::Parsing::Standard
          # Information about the employee's bank account.
          # @return [Mindee::Product::FR::Payslip::PayslipV2BankAccountDetail]
          attr_reader :bank_account_details
          # Information about the employee.
          # @return [Mindee::Product::FR::Payslip::PayslipV2Employee]
          attr_reader :employee
          # Information about the employer.
          # @return [Mindee::Product::FR::Payslip::PayslipV2Employer]
          attr_reader :employer
          # Information about the employment.
          # @return [Mindee::Product::FR::Payslip::PayslipV2Employment]
          attr_reader :employment
          # Detailed information about the pay.
          # @return [Mindee::Product::FR::Payslip::PayslipV2PayDetail]
          attr_reader :pay_detail
          # Information about the pay period.
          # @return [Mindee::Product::FR::Payslip::PayslipV2PayPeriod]
          attr_reader :pay_period
          # Information about paid time off.
          # @return [Mindee::Product::FR::Payslip::PayslipV2Pto]
          attr_reader :pto
          # Detailed information about the earnings.
          # @return [Array<Mindee::Product::FR::Payslip::PayslipV2SalaryDetail>]
          attr_reader :salary_details

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super(prediction)
            @bank_account_details = PayslipV2BankAccountDetail.new(prediction['bank_account_details'], page_id)
            @employee = PayslipV2Employee.new(prediction['employee'], page_id)
            @employer = PayslipV2Employer.new(prediction['employer'], page_id)
            @employment = PayslipV2Employment.new(prediction['employment'], page_id)
            @pay_detail = PayslipV2PayDetail.new(prediction['pay_detail'], page_id)
            @pay_period = PayslipV2PayPeriod.new(prediction['pay_period'], page_id)
            @pto = PayslipV2Pto.new(prediction['pto'], page_id)
            @salary_details = []
            prediction['salary_details'].each do |item|
              @salary_details.push(Payslip::PayslipV2SalaryDetail.new(item, page_id))
            end
          end

          # @return [String]
          def to_s
            employee = @employee.to_s
            employer = @employer.to_s
            bank_account_details = @bank_account_details.to_s
            employment = @employment.to_s
            salary_details = salary_details_to_s
            pay_detail = @pay_detail.to_s
            pto = @pto.to_s
            pay_period = @pay_period.to_s
            out_str = String.new
            out_str << "\n:Employee:"
            out_str << employee
            out_str << "\n:Employer:"
            out_str << employer
            out_str << "\n:Bank Account Details:"
            out_str << bank_account_details
            out_str << "\n:Employment:"
            out_str << employment
            out_str << "\n:Salary Details:"
            out_str << salary_details
            out_str << "\n:Pay Detail:"
            out_str << pay_detail
            out_str << "\n:PTO:"
            out_str << pto
            out_str << "\n:Pay Period:"
            out_str << pay_period
            out_str[1..].to_s
          end

          private

          # @param char [String]
          # @return [String]
          def salary_details_separator(char)
            out_str = String.new
            out_str << '  '
            out_str << "+#{char * 14}"
            out_str << "+#{char * 11}"
            out_str << "+#{char * 38}"
            out_str << "+#{char * 11}"
            out_str << '+'
            out_str
          end

          # @return [String]
          def salary_details_to_s
            return '' if @salary_details.empty?

            line_items = @salary_details.map(&:to_table_line).join("\n#{salary_details_separator('-')}\n  ")
            out_str = String.new
            out_str << "\n#{salary_details_separator('-')}"
            out_str << "\n  |"
            out_str << ' Amount       |'
            out_str << ' Base      |'
            out_str << ' Description                          |'
            out_str << ' Rate      |'
            out_str << "\n#{salary_details_separator('=')}"
            out_str << "\n  #{line_items}"
            out_str << "\n#{salary_details_separator('-')}"
            out_str
          end
        end
      end
    end
  end
end
