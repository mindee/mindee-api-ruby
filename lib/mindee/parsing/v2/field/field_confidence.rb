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
          VALID_VALUES = ['Certain', 'High', 'Medium', 'Low'].freeze

          # @param value [String] The confidence level value.
          # @raise [ArgumentError] If the value is not a valid confidence level.
          def initialize(value)
            case value
            when 'Certain' then @value = CERTAIN
            when 'High' then @value = HIGH
            when 'Medium' then @value = MEDIUM
            when 'Low' then @value = LOW
            else
              raise ArgumentError,
                    "Invalid confidence level: '#{value}'. Must be one of: #{VALID_VALUES.join(', ')}"
            end

            @value = value
          end

          # String representation of the confidence level.
          # @return [String] The confidence level value.
          def to_s
            @value
          end

          # String representation of the confidence level.
          # @return [Integer] The confidence level value as an integer: 1 is LOW, 4 is HIGH.
          def to_i
            val_to_i(@value)
          end

          # Inspect method for debugging.
          # @return [String] Debug representation.
          def inspect
            "#<#{self.class.name}:#{@value}>"
          end

          # Using 'case' breaks steep ...
          # rubocop:disable Style/CaseLikeIf

          # Equality of two FieldConfidence instances.
          # @param other [String, Integer, FieldConfidence] The other confidence to compare.
          # @return [Boolean] `true` if they have the same value.
          def ==(other)
            if other.is_a?(FieldConfidence)
              @value == other.value
            elsif other.is_a?(String)
              @value == other
            elsif other.is_a?(Integer)
              to_i == other
            else
              raise ArgumentError, "Invalid type: #{other.class}"
            end
          end

          # Greater than or equality of two FieldConfidence instances.
          # @param other [String, Integer, FieldConfidence] The other confidence to compare.
          def >=(other)
            if other.is_a?(FieldConfidence)
              to_i >= val_to_i(other.value)
            elsif other.is_a?(String)
              to_i >= val_to_i(other)
            elsif other.is_a?(Integer)
              to_i >= other
            else
              raise ArgumentError, "Invalid type: #{other.class}"
            end
          end

          # less than or equality of two FieldConfidence instances.
          # # @param other [String, Integer, FieldConfidence] The other confidence to compare.
          def <=(other)
            if other.is_a?(FieldConfidence)
              to_i <= val_to_i(other.value)
            elsif other.is_a?(String)
              to_i <= val_to_i(other)
            elsif other.is_a?(Integer)
              to_i <= other
            else
              raise ArgumentError, "Invalid type: #{other.class}"
            end
          end

          # rubocop:enable Style/CaseLikeIf

          # Aliases for the comparison operators.
          alias eql? ==
          alias gteql? >=
          alias lteql? <=

          protected

          def val_to_i(value)
            case value
            when CERTAIN then 4
            when HIGH then 3
            when MEDIUM then 2
            when LOW then 1
            else
              raise ArgumentError,
                    "Invalid confidence level: '#{value}'. Must be one of: #{VALID_VALUES.join(', ')}"
            end
          end
        end
      end
    end
  end
end
