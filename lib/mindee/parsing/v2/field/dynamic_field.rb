# frozen_string_literal: true

module Mindee
  module Parsing
    module V2
      module Field
        # Extension of the base field class for V2 fields, with location data.
        class DynamicField < BaseField
          # @return [Array<FieldLocation>, nil] List of possible locations for a field.
          attr_accessor :locations

          # @param raw_prediction [Hash] Raw prediction hash.
          # @param indent_level [Integer] Level of indentation for rst display.
          def initialize(raw_prediction, indent_level = 0)
            super

            # Process locations if present
            return unless raw_prediction['locations']

            @locations = raw_prediction['locations'].map do |location|
              location ? FieldLocation.new(location) : nil
            end.compact
          end
        end
      end
    end
  end
end
