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
      end
    end
  end
end
