# frozen_string_literal: true

require_relative 'base_field'

module Mindee
  module Parsing
    module Standard
      # Represents basic text information.
      class StringField < Field
        # Value as String
        # @return [String, nil]
        attr_reader :value
        # Value as String
        # @return [String, nil]
        attr_reader :raw_value

        def initialize(prediction, page_id = nil, reconstructed: false)
          super
          @raw_value = prediction['raw_value']
        end
      end
    end
  end
end
