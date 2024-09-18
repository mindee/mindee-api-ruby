# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module Resume
      # The list of certificates obtained by the candidate.
      class ResumeV1Certificate < Mindee::Parsing::Standard::FeatureField
        include Mindee::Parsing::Standard
        # The grade obtained for the certificate.
        # @return [String]
        attr_reader :grade
        # The name of certification.
        # @return [String]
        attr_reader :name
        # The organization or institution that issued the certificate.
        # @return [String]
        attr_reader :provider
        # The year when a certificate was issued or received.
        # @return [String]
        attr_reader :year

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super(prediction, page_id)
          @grade = prediction['grade']
          @name = prediction['name']
          @provider = prediction['provider']
          @year = prediction['year']
          @page_id = page_id
        end

        # @return [Hash]
        def printable_values
          printable = {}
          printable[:grade] = format_for_display(@grade)
          printable[:name] = format_for_display(@name)
          printable[:provider] = format_for_display(@provider)
          printable[:year] = format_for_display(@year)
          printable
        end

        # @return [Hash]
        def table_printable_values
          printable = {}
          printable[:grade] = format_for_display(@grade, 10)
          printable[:name] = format_for_display(@name, 30)
          printable[:provider] = format_for_display(@provider, 25)
          printable[:year] = format_for_display(@year, nil)
          printable
        end

        # @return [String]
        def to_table_line
          printable = table_printable_values
          out_str = String.new
          out_str << format('| %- 11s', printable[:grade])
          out_str << format('| %- 31s', printable[:name])
          out_str << format('| %- 26s', printable[:provider])
          out_str << format('| %- 5s', printable[:year])
          out_str << '|'
        end

        # @return [String]
        def to_s
          printable = printable_values
          out_str = String.new
          out_str << "\n  :Grade: #{printable[:grade]}"
          out_str << "\n  :Name: #{printable[:name]}"
          out_str << "\n  :Provider: #{printable[:provider]}"
          out_str << "\n  :Year: #{printable[:year]}"
          out_str
        end
      end
    end
  end
end
