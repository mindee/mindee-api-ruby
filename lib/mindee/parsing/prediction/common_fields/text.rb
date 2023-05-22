# frozen_string_literal: true

require_relative 'base'

module Mindee
  # Represents basic text information.
  class TextField < Field
    # Value as String
    # @return [String, nil]
    attr_reader :value
  end
end
