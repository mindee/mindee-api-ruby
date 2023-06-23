# frozen_string_literal: true

module Mindee
  module Parsing
    module Custom
      # Document classification (custom docs)
      class ClassificationField
        # The classification value
        # @return [String]
        attr_reader :value
        # The confidence score, value will be between 0.0 and 1.0
        # @return [Float]
        attr_accessor :confidence

        # @param prediction [Hash]
        def initialize(prediction)
          @value = prediction['value']
          @confidence = prediction['confidence']
        end

        def to_s
          @value.nil? ? '' : @value
        end
      end
    end
  end
end
