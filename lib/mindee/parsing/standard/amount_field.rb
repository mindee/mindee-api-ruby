# frozen_string_literal: true

require_relative 'base_field'

module Mindee
  module Parsing
    module Standard
      # Represents tax information.
      class AmountField < BaseField
        # Amount value as 3 decimal float
        # @return [Float, nil]
        attr_reader :value

        def initialize(prediction, page_id, reconstructed: false)
          super
          @value = @value.to_f.round(3).to_f unless @value.to_s.empty?
        end

        # @return [String]
        def to_s
          @value.nil? ? '' : BaseField.float_to_string(@value.to_f)
        end
      end
    end
  end
end
