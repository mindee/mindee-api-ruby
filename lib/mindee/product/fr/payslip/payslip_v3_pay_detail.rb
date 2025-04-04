# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module Payslip
        # Detailed information about the pay.
        class PayslipV3PayDetail < Mindee::Parsing::Standard::FeatureField
          include Mindee::Parsing::Standard
          # The gross salary of the employee.
          # @return [Float]
          attr_reader :gross_salary
          # The year-to-date gross salary of the employee.
          # @return [Float]
          attr_reader :gross_salary_ytd
          # The income tax rate of the employee.
          # @return [Float]
          attr_reader :income_tax_rate
          # The income tax withheld from the employee's pay.
          # @return [Float]
          attr_reader :income_tax_withheld
          # The net paid amount of the employee.
          # @return [Float]
          attr_reader :net_paid
          # The net paid amount before tax of the employee.
          # @return [Float]
          attr_reader :net_paid_before_tax
          # The net taxable amount of the employee.
          # @return [Float]
          attr_reader :net_taxable
          # The year-to-date net taxable amount of the employee.
          # @return [Float]
          attr_reader :net_taxable_ytd
          # The total cost to the employer.
          # @return [Float]
          attr_reader :total_cost_employer
          # The total taxes and deductions of the employee.
          # @return [Float]
          attr_reader :total_taxes_and_deductions

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super
            @gross_salary = prediction['gross_salary']
            @gross_salary_ytd = prediction['gross_salary_ytd']
            @income_tax_rate = prediction['income_tax_rate']
            @income_tax_withheld = prediction['income_tax_withheld']
            @net_paid = prediction['net_paid']
            @net_paid_before_tax = prediction['net_paid_before_tax']
            @net_taxable = prediction['net_taxable']
            @net_taxable_ytd = prediction['net_taxable_ytd']
            @total_cost_employer = prediction['total_cost_employer']
            @total_taxes_and_deductions = prediction['total_taxes_and_deductions']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:gross_salary] =
              @gross_salary.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@gross_salary)
            printable[:gross_salary_ytd] =
              @gross_salary_ytd.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@gross_salary_ytd)
            printable[:income_tax_rate] =
              @income_tax_rate.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@income_tax_rate)
            printable[:income_tax_withheld] =
              if @income_tax_withheld.nil?
                ''
              else
                Parsing::Standard::BaseField.float_to_string(@income_tax_withheld)
              end
            printable[:net_paid] =
              @net_paid.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@net_paid)
            printable[:net_paid_before_tax] =
              if @net_paid_before_tax.nil?
                ''
              else
                Parsing::Standard::BaseField.float_to_string(@net_paid_before_tax)
              end
            printable[:net_taxable] =
              @net_taxable.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@net_taxable)
            printable[:net_taxable_ytd] =
              @net_taxable_ytd.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@net_taxable_ytd)
            printable[:total_cost_employer] =
              if @total_cost_employer.nil?
                ''
              else
                Parsing::Standard::BaseField.float_to_string(@total_cost_employer)
              end
            printable[:total_taxes_and_deductions] =
              if @total_taxes_and_deductions.nil?
                ''
              else
                Parsing::Standard::BaseField.float_to_string(@total_taxes_and_deductions)
              end
            printable
          end

          # @return [String]
          def to_s
            printable = printable_values
            out_str = String.new
            out_str << "\n  :Gross Salary: #{printable[:gross_salary]}"
            out_str << "\n  :Gross Salary YTD: #{printable[:gross_salary_ytd]}"
            out_str << "\n  :Income Tax Rate: #{printable[:income_tax_rate]}"
            out_str << "\n  :Income Tax Withheld: #{printable[:income_tax_withheld]}"
            out_str << "\n  :Net Paid: #{printable[:net_paid]}"
            out_str << "\n  :Net Paid Before Tax: #{printable[:net_paid_before_tax]}"
            out_str << "\n  :Net Taxable: #{printable[:net_taxable]}"
            out_str << "\n  :Net Taxable YTD: #{printable[:net_taxable_ytd]}"
            out_str << "\n  :Total Cost Employer: #{printable[:total_cost_employer]}"
            out_str << "\n  :Total Taxes and Deductions: #{printable[:total_taxes_and_deductions]}"
            out_str
          end
        end
      end
    end
  end
end
