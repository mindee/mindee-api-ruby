# frozen_string_literal: true

require_relative 'base'

module Mindee
  # Represents tax information.
  class Amount < Field
    # Amount value as 3 decimal float
    # @return [Float]
    attr_reader :value

    def initialize(prediction, page_id, reconstructed: false)
      super
      @value = @value.round(3) unless @value.nil?
    end
  end
end
