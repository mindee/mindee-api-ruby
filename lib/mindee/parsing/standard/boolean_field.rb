# frozen_string_literal: true

require_relative 'base_field'

module Mindee
  module Parsing
    module Standard
      # Represents basic text information.
      class BooleanField < Field
        # Value as Boolean
        # @return [Boolean, nil]
        attr_reader :value

        def initialize(prediction, page_id = nil, reconstructed: false)
          super
        end

        def to_s
          value ? 'True' : 'False'
        end
      end
    end
  end
end
