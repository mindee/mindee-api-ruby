# frozen_string_literal: true

module Mindee
  module Parsing
    module V2
      module Field
        # Confidence level of a field as returned by the V2 API.
        class FieldConfidence
          # @return [String] The confidence level value.
          attr_reader :value

          # Absolute certainty about the field's extraction.
          CERTAIN = 'Certain'
          # High certainty about the field's extraction.
          HIGH = 'High'
          # Medium certainty about the field's extraction.
          MEDIUM = 'Medium'
          # Low certainty about the field's extraction.
          LOW = 'Low'

          # List of valid values, as frozen strings.
          VALID_VALUES = [CERTAIN, HIGH, MEDIUM, LOW].freeze

          # @param value [String] The confidence level value.
          # @raise [ArgumentError] If the value is not a valid confidence level.
          def initialize(value)
            unless VALID_VALUES.include?(value)
              raise ArgumentError,
                    "Invalid confidence level: #{value}. Must be one of: #{VALID_VALUES.join(', ')}"
            end

            @value = value
          end

          # Create a FieldConfidence from a string value.
          # @param value [String] The confidence level string.
          # @return [FieldConfidence] The confidence instance.
          def self.from_string(value)
            new(value)
          end

          # Check if this is a certain confidence level.
          # @return [Boolean] True if confidence is certain.
          def certain?
            @value == CERTAIN
          end

          # Check if this is a high confidence level.
          # @return [Boolean] True if confidence is high.
          def high?
            @value == HIGH
          end

          # Check if this is a medium confidence level.
          # @return [Boolean] True if confidence is medium.
          def medium?
            @value == MEDIUM
          end

          # Check if this is a low confidence level.
          # @return [Boolean] True if confidence is low.
          def low?
            @value == LOW
          end

          # String representation of the confidence level.
          # @return [String] The confidence level value.
          def to_s
            @value
          end

          # Compare two FieldConfidence instances.
          # @param other [FieldConfidence] The other confidence to compare.
          # @return [Boolean] True if they have the same value.
          def ==(other)
            other.is_a?(FieldConfidence) && @value == other.value
          end

          # Make instances comparable and hashable
          alias eql? ==

          # Inspect method for debugging.
          # @return [String] Debug representation.
          def inspect
            "#<#{self.class.name}:#{@value}>"
          end
        end
      end
    end
  end
end
