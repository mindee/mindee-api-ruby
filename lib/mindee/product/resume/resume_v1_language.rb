# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module Resume
      # The list of languages that a person is proficient in, as stated in their resume.
      class ResumeV1Language < Mindee::Parsing::Standard::FeatureField
        include Mindee::Parsing::Standard
        # The language ISO 639 code.
        # @return [String]
        attr_reader :language
        # The level for the language. Possible values: 'Fluent', 'Proficient', 'Intermediate' and 'Beginner'.
        # @return [String]
        attr_reader :level

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super(prediction, page_id)
          @language = prediction['language']
          @level = prediction['level']
          @page_id = page_id
        end

        # @return [Hash]
        def printable_values
          printable = {}
          printable[:language] = format_for_display(@language, nil)
          printable[:level] = format_for_display(@level, 20)
          printable
        end

        # @return [String]
        def to_table_line
          printable = printable_values
          out_str = String.new
          out_str << format('| %- 9s', printable[:language])
          out_str << format('| %- 21s', printable[:level])
          out_str << '|'
        end

        # @return [String]
        def to_s
          printable = printable_values
          out_str = String.new
          out_str << "\n  :Language: #{printable[:language]}"
          out_str << "\n  :Level: #{printable[:level]}"
          out_str
        end
      end
    end
  end
end
