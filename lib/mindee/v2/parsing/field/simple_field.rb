# frozen_string_literal: true

require_relative 'base_field'

module Mindee
  module V2
    module Parsing
      module Field
        # A simple field with a scalar value.
        class SimpleField < BaseField
          # @return [String, Integer, Float, Boolean, nil] Value contained in the field.
          attr_reader :value

          # @param server_response [Hash] Raw server response hash.
          # @param indent_level [Integer] Level of indentation for rst display.
          def initialize(server_response, indent_level = 0)
            super
            value = server_response['value']
            @value = if value.is_a?(Integer)
                       value.to_f
                     else
                       value
                     end
          end

          # String representation of the field value.
          # @return [String] String representation of the value.
          def to_s
            return '' if @value.nil?

            if @value.is_a?(TrueClass) || @value.is_a?(FalseClass)
              @value ? 'True' : 'False'
            elsif @value.is_a?(Integer) || @value.is_a?(Float)
              num = @value # @type var num: Integer | Float
              format_numeric_value(num)
            else
              @value.to_s
            end
          end

          # Retrieves the field value as a Float.
          # @return [Float, nil]
          # @raise [RuntimeError] If the value is not a Float.
          def float_value
            raise "Value is not a float: #{@value.class}" unless @value.nil? || @value.is_a?(Float)

            val = @value
            val.is_a?(Float) ? val : nil # @type var val: Float | nil
          end

          # Retrieves the field value as a String.
          # @return [String, nil]
          # @raise [RuntimeError] If the value is not a String.
          def string_value
            raise "Value is not a string: #{@value.class}" unless @value.nil? || @value.is_a?(String)

            val = @value
            val.is_a?(String) ? val : nil # @type var val: String | nil
          end

          # Retrieves the field value as a Boolean.
          # @return [Boolean, nil]
          # @raise [RuntimeError] If the value is not a Boolean.
          def boolean_value
            unless @value.nil? || @value.is_a?(TrueClass) || @value.is_a?(FalseClass)
              raise "Value is not a boolean: #{@value.class}"
            end

            val = @value
            @value.is_a?(TrueClass) || @value.is_a?(FalseClass) ? val : nil # @type var val: bool | nil
          end

          private

          # Format numeric values to display '.0' in string reps.
          # @param value [Numeric] The numeric value to format.
          # @return [String] Formatted numeric string.
          def format_numeric_value(value)
            float_value = value.to_f

            if float_value == float_value.to_i
              format('%.1f', float_value)
            else
              formatted = format('%.5f', float_value)
              formatted.sub(%r{\.?0+$}, '')
            end
          end
        end
      end
    end
  end
end
