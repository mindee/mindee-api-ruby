# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module Resume
      # The list of values that represent the professional experiences of an individual in their global resume.
      class ResumeV1ProfessionalExperience < Mindee::Parsing::Standard::FeatureField
        include Mindee::Parsing::Standard
        # The type of contract for a professional experience. Possible values: 'Full-Time', 'Part-Time',
        # 'Internship' and 'Freelance'.
        # @return [String]
        attr_reader :contract_type
        # The specific department or division within a company where the professional experience was gained.
        # @return [String]
        attr_reader :department
        # The name of the company or organization where the candidate has worked.
        # @return [String]
        attr_reader :employer
        # The month when a professional experience ended.
        # @return [String]
        attr_reader :end_month
        # The year when a professional experience ended.
        # @return [String]
        attr_reader :end_year
        # The position or job title held by the individual in their previous work experience.
        # @return [String]
        attr_reader :role
        # The month when a professional experience began.
        # @return [String]
        attr_reader :start_month
        # The year when a professional experience began.
        # @return [String]
        attr_reader :start_year

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super(prediction, page_id)
          @contract_type = prediction['contract_type']
          @department = prediction['department']
          @employer = prediction['employer']
          @end_month = prediction['end_month']
          @end_year = prediction['end_year']
          @role = prediction['role']
          @start_month = prediction['start_month']
          @start_year = prediction['start_year']
          @page_id = page_id
        end

        # @return [Hash]
        def printable_values
          printable = {}
          printable[:contract_type] = format_for_display(@contract_type, 15)
          printable[:department] = format_for_display(@department, 10)
          printable[:employer] = format_for_display(@employer, 25)
          printable[:end_month] = format_for_display(@end_month, nil)
          printable[:end_year] = format_for_display(@end_year, nil)
          printable[:role] = format_for_display(@role, 20)
          printable[:start_month] = format_for_display(@start_month, nil)
          printable[:start_year] = format_for_display(@start_year, nil)
          printable
        end

        # @return [String]
        def to_table_line
          printable = printable_values
          out_str = String.new
          out_str << format('| %- 16s', printable[:contract_type])
          out_str << format('| %- 11s', printable[:department])
          out_str << format('| %- 26s', printable[:employer])
          out_str << format('| %- 10s', printable[:end_month])
          out_str << format('| %- 9s', printable[:end_year])
          out_str << format('| %- 21s', printable[:role])
          out_str << format('| %- 12s', printable[:start_month])
          out_str << format('| %- 11s', printable[:start_year])
          out_str << '|'
        end

        # @return [String]
        def to_s
          printable = printable_values
          out_str = String.new
          out_str << "\n  :Contract Type: #{printable[:contract_type]}"
          out_str << "\n  :Department: #{printable[:department]}"
          out_str << "\n  :Employer: #{printable[:employer]}"
          out_str << "\n  :End Month: #{printable[:end_month]}"
          out_str << "\n  :End Year: #{printable[:end_year]}"
          out_str << "\n  :Role: #{printable[:role]}"
          out_str << "\n  :Start Month: #{printable[:start_month]}"
          out_str << "\n  :Start Year: #{printable[:start_year]}"
          out_str
        end
      end
    end
  end
end
