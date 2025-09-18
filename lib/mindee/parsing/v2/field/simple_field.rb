# frozen_string_literal: true

require_relative 'base_field'

module Mindee
  module Parsing
    module V2
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
