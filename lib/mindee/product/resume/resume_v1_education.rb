# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module Resume
      # The list of values that represent the educational background of an individual.
      class ResumeV1Education < Mindee::Parsing::Standard::FeatureField
        include Mindee::Parsing::Standard
        # The area of study or specialization pursued by an individual in their educational background.
        # @return [String]
        attr_reader :degree_domain
        # The type of degree obtained by the individual, such as Bachelor's, Master's, or Doctorate.
        # @return [String]
        attr_reader :degree_type
        # The month when the education program or course was completed or is expected to be completed.
        # @return [String]
        attr_reader :end_month
        # The year when the education program or course was completed or is expected to be completed.
        # @return [String]
        attr_reader :end_year
        # The name of the school the individual went to.
        # @return [String]
        attr_reader :school
        # The month when the education program or course began.
        # @return [String]
        attr_reader :start_month
        # The year when the education program or course began.
        # @return [String]
        attr_reader :start_year

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super(prediction, page_id)
          @degree_domain = prediction['degree_domain']
          @degree_type = prediction['degree_type']
          @end_month = prediction['end_month']
          @end_year = prediction['end_year']
          @school = prediction['school']
          @start_month = prediction['start_month']
          @start_year = prediction['start_year']
          @page_id = page_id
        end

        # @return [Hash]
        def printable_values
          printable = {}
          printable[:degree_domain] = format_for_display(@degree_domain, 15)
          printable[:degree_type] = format_for_display(@degree_type, 25)
          printable[:end_month] = format_for_display(@end_month, nil)
          printable[:end_year] = format_for_display(@end_year, nil)
          printable[:school] = format_for_display(@school, 25)
          printable[:start_month] = format_for_display(@start_month, nil)
          printable[:start_year] = format_for_display(@start_year, nil)
          printable
        end

        # @return [String]
        def to_table_line
          printable = printable_values
          out_str = String.new
          out_str << format('| %- 16s', printable[:degree_domain])
          out_str << format('| %- 26s', printable[:degree_type])
          out_str << format('| %- 10s', printable[:end_month])
          out_str << format('| %- 9s', printable[:end_year])
          out_str << format('| %- 26s', printable[:school])
          out_str << format('| %- 12s', printable[:start_month])
          out_str << format('| %- 11s', printable[:start_year])
          out_str << '|'
        end

        # @return [String]
        def to_s
          printable = printable_values
          out_str = String.new
          out_str << "\n  :Domain: #{printable[:degree_domain]}"
          out_str << "\n  :Degree: #{printable[:degree_type]}"
          out_str << "\n  :End Month: #{printable[:end_month]}"
          out_str << "\n  :End Year: #{printable[:end_year]}"
          out_str << "\n  :School: #{printable[:school]}"
          out_str << "\n  :Start Month: #{printable[:start_month]}"
          out_str << "\n  :Start Year: #{printable[:start_year]}"
          out_str
        end
      end
    end
  end
end
