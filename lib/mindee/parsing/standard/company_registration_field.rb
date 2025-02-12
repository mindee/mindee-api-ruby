# frozen_string_literal: true

module Mindee
  module Parsing
    module Standard
      # Company registration number or code, and its type.
      class CompanyRegistrationField < BaseField
        # @return [String]
        attr_reader :type

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        # @param reconstructed [bool]
        def initialize(prediction, page_id, reconstructed: false)
          super
          @type = prediction['type']
        end

        # Table line representation of the values.
        # @return [String] The formatted table line, as a string.
        def to_table_line
          printable = printable_values
          format('| %<type>-15s | %<value>-20s ', type: printable['type'], value: printable['value'])
        end

        # @return [String]
        def to_s
          printable = printable_values
          format('Type: %<type>s, Value: %<value>s', type: printable['type'], value: printable['value'])
        end

        # Hashed representation of the values.
        # @return [Hash] Hash of the values.
        def printable_values
          printable = {}
          printable['type'] = type
          printable['value'] = value
          printable
        end
      end
    end
  end
end
