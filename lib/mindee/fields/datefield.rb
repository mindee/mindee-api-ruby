# frozen_string_literal: true

require 'date'

require_relative 'base'

module Mindee
  # Represents a date.
  class DateField < Field
    # @return [Date, nil]
    attr_reader :date_object
    # @return [String, nil]
    attr_reader :value
    # @return [String, nil]
    attr_reader :raw

    # @param prediction [Hash]
    # @param page_id [Integer, nil]
    def initialize(prediction, page_id)
      super
      return unless @value

      @date_object = Date.parse(@value)
      @raw = prediction['raw']
    end
  end
end
