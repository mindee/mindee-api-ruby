# frozen_string_literal: true

require_relative '../../geometry'
require_relative 'abstract_field'

module Mindee
  module Parsing
    module Standard
      # Base field object.
      class BaseField < AbstractField
        # @return [String, Numeric, Boolean]
        attr_reader :value
        # true if the field was reconstructed or computed using other fields.
        # @return [Boolean]
        attr_reader :reconstructed

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        # @param reconstructed [Boolean]
        def initialize(prediction, page_id, reconstructed: false)
          super(prediction, page_id)
          @value = prediction['value']
          @reconstructed = reconstructed
        end
      end
    end
  end
end
