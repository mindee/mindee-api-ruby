# frozen_string_literal: true

require_relative 'base_product'

module Mindee
  # Represents tax information.
  class AmountField < Field
    # Amount value as 3 decimal float
    # @return [Float, nil]
    attr_reader :value

    def initialize(prediction, page_id, reconstructed: false)
      super
      @value = @value.round(3) unless @value.nil?
    end

    def to_s
      Field.float_to_string(@value)
    end
  end
end
