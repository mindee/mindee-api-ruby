# frozen_string_literal: true

require_relative 'base_field'

module Mindee
  module V1
    module Parsing
      module Standard
        # Represents a classifier value.
        class ClassificationField < BaseField
          # Value as String
          # @return [String]
          attr_reader :value
        end
      end
    end
  end
end
