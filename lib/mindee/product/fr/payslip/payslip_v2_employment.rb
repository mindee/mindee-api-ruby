# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module Payslip
        # Information about the employment.
        class PayslipV2Employment < Mindee::Parsing::Standard::FeatureField
          include Mindee::Parsing::Standard
          # The category of the employment.
          # @return [String]
          attr_reader :category
          # The coefficient of the employment.
          # @return [Float]
          attr_reader :coefficient
          # The collective agreement of the employment.
          # @return [String]
          attr_reader :collective_agreement
          # The job title of the employee.
          # @return [String]
          attr_reader :job_title
          # The position level of the employment.
          # @return [String]
          attr_reader :position_level
          # The start date of the employment.
          # @return [String]
          attr_reader :start_date

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super
            @category = prediction['category']
            @coefficient = prediction['coefficient']
            @collective_agreement = prediction['collective_agreement']
            @job_title = prediction['job_title']
            @position_level = prediction['position_level']
            @start_date = prediction['start_date']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:category] = format_for_display(@category)
            printable[:coefficient] = @coefficient.nil? ? '' : BaseField.float_to_string(@coefficient)
            printable[:collective_agreement] = format_for_display(@collective_agreement)
            printable[:job_title] = format_for_display(@job_title)
            printable[:position_level] = format_for_display(@position_level)
            printable[:start_date] = format_for_display(@start_date)
            printable
          end

          # @return [String]
          def to_s
            printable = printable_values
            out_str = String.new
            out_str << "\n  :Category: #{printable[:category]}"
            out_str << "\n  :Coefficient: #{printable[:coefficient]}"
            out_str << "\n  :Collective Agreement: #{printable[:collective_agreement]}"
            out_str << "\n  :Job Title: #{printable[:job_title]}"
            out_str << "\n  :Position Level: #{printable[:position_level]}"
            out_str << "\n  :Start Date: #{printable[:start_date]}"
            out_str
          end
        end
      end
    end
  end
end
