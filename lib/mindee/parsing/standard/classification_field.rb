# frozen_string_literal: true

require_relative 'base_field'

module Mindee
  # Represents a classifier value.
  class ClassificationField < Field
    # Value as String
    # @return [String]
    attr_reader :value
  end
end
