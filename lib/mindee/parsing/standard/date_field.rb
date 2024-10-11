# frozen_string_literal: true

require 'date'

require_relative 'base_field'

module Mindee
  module Parsing
    module Standard
      # Represents a date.
      class DateField < Field
        # The date as a standard Ruby `Date` object.
        # @return [Date, nil]
        attr_reader :date_object
        # The ISO 8601 representation of the date, regardless of the `raw` contents.
        # @return [String, nil]
        attr_reader :value
        # The textual representation of the date as found on the document.
        # @return [String, nil]
        attr_reader :raw
        # Whether the field was computed or retrieved directly from the document.
        # @return [Boolean, nil]
        attr_reader :is_computed

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @is_computed = prediction['is_computed']
          return unless @value

          @date_object = Date.parse(@value)
          @raw = prediction['raw']
        end
      end
    end
  end
end
