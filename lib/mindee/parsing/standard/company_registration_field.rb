# frozen_string_literal: true

module Mindee
  module Parsing
    module Standard
      # Company registration number or code, and its type.
      class CompanyRegistrationField < Field
        # @return [String]
        attr_reader :type

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        # @param reconstructed [Boolean]
        def initialize(prediction, page_id, reconstructed: false)
          super
          @type = prediction['type']
        end

        def to_table_line
          printable = printable_values
          format('| %-15s | %-20s ', printable['type'], printable['value'])
        end

        def to_s
          printable = printable_values
          format('Type: %<type>s, Value: %<value>s', type: printable['type'], value: printable['value'])
        end

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
