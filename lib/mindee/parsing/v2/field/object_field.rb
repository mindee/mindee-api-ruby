# frozen_string_literal: true

require_relative 'base_field'
require_relative 'inference_fields'

module Mindee
  module Parsing
    module V2
      module Field
        # A field containing a nested set of inference fields.
        class ObjectField < DynamicField
          # @return [InferenceFields] Fields contained in the object.
          attr_reader :fields

          # @param raw_prediction [Hash] Raw server response hash.
          # @param indent_level [Integer] Level of indentation for rst display.
          def initialize(raw_prediction, indent_level = 0)
            super

            inner_fields = raw_prediction.fetch('fields', raw_prediction)
            @fields = InferenceFields.new(inner_fields, @indent_level + 1)
          end

          # String representation of the object field.
          # @return [String] String representation with newline prefix.
          def to_s
            return "\n" unless @fields && !@fields.empty?

            "\n#{@fields.to_s(1)}"
          end

          # String representation suitable for list display.
          # @return [String] String representation without leading spaces.
          def to_s_from_list
            return '' unless @fields && !@fields.empty?

            field_str = @fields.to_s(2)
            # Remove the first 4 characters
            field_str.length > 4 ? field_str[4..] : ''
          end

          # String representation of a single object field
          # @return [String] Multi-line string with proper indentation.
          def single_str
            return '' unless @fields && !@fields.empty?

            out_str = ''
            indent = ' ' * @indent_level

            @fields.each do |field_key, field_value|
              value_str = field_value && !field_value.to_s.empty? ? field_value.to_s : ''
              out_str += "\n#{indent}  :#{field_key}: #{value_str}"
            end

            out_str
          end

          # String representation for multi-object display
          # @return [String] Formatted string for list context.
          def multi_str
            return '' unless @fields && !@fields.empty?

            out_str = ''
            indent = ' ' * @indent_level
            first = true

            @fields.each do |field_key, field_value|
              value_str = field_value ? field_value.to_s : ''

              if first
                out_str += "#{indent}:#{field_key}: #{value_str}"
                first = false
              else
                out_str += "\n#{indent}    :#{field_key}: #{value_str}"
              end
            end

            out_str
          end

          # Allow dot notation access to nested fields.
          # @param method_name [Symbol] The method name (field key).
          # @return [ObjectField, nil] The field or nil if not found.
          def method_missing(method_name, ...)
            if @fields.respond_to?(method_name)
              @fields.send(method_name, ...)
            else
              super
            end
          end

          # Check if method_missing should handle the method.
          # @param method_name [Symbol] The method name.
          # @return [Boolean] True if the method should be handled.
          def respond_to_missing?(method_name, include_private = false)
            @fields.respond_to?(method_name) || super
          end
        end
      end
    end
  end
end
