# frozen_string_literal: true

require_relative 'base'

module Mindee
  # Represents tax information.
  class TextField < Field
    # Amount value as 3 decimal float
    # @return [String, nil]
    attr_reader :value
  end
end
