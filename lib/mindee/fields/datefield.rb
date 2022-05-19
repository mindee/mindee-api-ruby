# frozen_string_literal: true

require 'date'

require_relative 'base'

module Mindee
  # Represents a date.
  class DateField < Field
    attr_reader :date_object

    def initialize(prediction, page_id)
      super
      return unless @value

      @date_object = Date.parse(@value) if @value
    end
  end
end
