# frozen_string_literal: true

require_relative '../../../parsing'
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
        # Payslip API version 3.0 document data.
        class PayslipV3Document < Mindee::Parsing::Common::Prediction
          include Mindee::Parsing::Standard
          # Information about the employee's bank account.
          # @return [Mindee::Product::FR::Payslip::PayslipV3BankAccountDetail]
          attr_reader :bank_account_details
          # Information about the employee.
          # @return [Mindee::Product::FR::Payslip::PayslipV3Employee]
          attr_reader :employee
          # Information about the employer.
          # @return [Mindee::Product::FR::Payslip::PayslipV3Employer]
          attr_reader :employer
          # Information about the employment.
          # @return [Mindee::Product::FR::Payslip::PayslipV3Employment]
          attr_reader :employment
          # Information about paid time off.
          # @return [Array<Mindee::Product::FR::Payslip::PayslipV3PaidTimeOff>]
          attr_reader :paid_time_off
          # Detailed information about the pay.
          # @return [Mindee::Product::FR::Payslip::PayslipV3PayDetail]
          attr_reader :pay_detail
          # Information about the pay period.
          # @return [Mindee::Product::FR::Payslip::PayslipV3PayPeriod]
          attr_reader :pay_period
          # Detailed information about the earnings.
          # @return [Array<Mindee::Product::FR::Payslip::PayslipV3SalaryDetail>]
          attr_reader :salary_details

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super(prediction, page_id)
            @bank_account_details = Product::FR::Payslip::PayslipV3BankAccountDetail.new(prediction['bank_account_details'], page_id)
            @employee = Product::FR::Payslip::PayslipV3Employee.new(prediction['employee'], page_id)
            @employer = Product::FR::Payslip::PayslipV3Employer.new(prediction['employer'], page_id)
            @employment = Product::FR::Payslip::PayslipV3Employment.new(prediction['employment'], page_id)
            @paid_time_off = [] # : Array[Payslip::PayslipV3PaidTimeOff]
            prediction['paid_time_off'].each do |item|
              @paid_time_off.push(Payslip::PayslipV3PaidTimeOff.new(item, page_id))
            end
            @pay_detail = Product::FR::Payslip::PayslipV3PayDetail.new(prediction['pay_detail'], page_id)
            @pay_period = Product::FR::Payslip::PayslipV3PayPeriod.new(prediction['pay_period'], page_id)
            @salary_details = [] # : Array[Payslip::PayslipV3SalaryDetail]
            prediction['salary_details'].each do |item|
              @salary_details.push(Payslip::PayslipV3SalaryDetail.new(item, page_id))
            end
          end

          # @return [String]
          def to_s
            pay_period = @pay_period.to_s
            employee = @employee.to_s
            employer = @employer.to_s
            bank_account_details = @bank_account_details.to_s
            employment = @employment.to_s
            salary_details = salary_details_to_s
            pay_detail = @pay_detail.to_s
            paid_time_off = paid_time_off_to_s
            out_str = String.new
            out_str << "\n:Pay Period:"
            out_str << pay_period
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
            out_str << "\n:Paid Time Off:"
            out_str << paid_time_off
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
            out_str << "+#{char * 8}"
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
            out_str << ' Number |'
            out_str << ' Rate      |'
            out_str << "\n#{salary_details_separator('=')}"
            out_str << "\n  #{line_items}"
            out_str << "\n#{salary_details_separator('-')}"
            out_str
          end

          # @param char [String]
          # @return [String]
          def paid_time_off_separator(char)
            out_str = String.new
            out_str << '  '
            out_str << "+#{char * 11}"
            out_str << "+#{char * 8}"
            out_str << "+#{char * 13}"
            out_str << "+#{char * 11}"
            out_str << "+#{char * 11}"
            out_str << '+'
            out_str
          end

          # @return [String]
          def paid_time_off_to_s
            return '' if @paid_time_off.empty?

            line_items = @paid_time_off.map(&:to_table_line).join("\n#{paid_time_off_separator('-')}\n  ")
            out_str = String.new
            out_str << "\n#{paid_time_off_separator('-')}"
            out_str << "\n  |"
            out_str << ' Accrued   |'
            out_str << ' Period |'
            out_str << ' Type        |'
            out_str << ' Remaining |'
            out_str << ' Used      |'
            out_str << "\n#{paid_time_off_separator('=')}"
            out_str << "\n  #{line_items}"
            out_str << "\n#{paid_time_off_separator('-')}"
            out_str
          end
        end
      end
    end
  end
end
