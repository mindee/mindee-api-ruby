# frozen_string_literal: true

require_relative 'base_field'

module Mindee
  module Parsing
    module V2
      module Field
        # Collection of inference fields that extends Hash functionality.
        class InferenceFields < Hash
          # @return [Integer] Level of indentation for rst display.
          attr_reader :indent_level

          # @param server_response [Hash] Raw server response hash.
          # @param indent_level [Integer] Level of indentation for rst display.
          def initialize(server_response, indent_level = 0)
            super()
            @indent_level = indent_level

            server_response.each do |key, value|
              self[key] = BaseField.create_field(value, 1)
            end
          end

          # Get a field by key with nil fallback.
          # @param key [String] Field key to retrieve.
          # @return [BaseField, nil] The field or nil if not found.
          def get(key)
            self[key]
          end

          # Allow dot notation access to fields.
          # @param method_name [Symbol] The method name (field key).
          # @return [BaseField, nil] The field or nil if not found.
          def method_missing(method_name, *args, &block)
            key = method_name.to_s
            if key?(key)
              self[key]
            else
              super
            end
          end

          # Check if method_missing should handle the method.
          # @param method_name [Symbol] The method name.
          # @return [Boolean] True if the method should be handled.
          def respond_to_missing?(method_name, include_private = false)
            key?(method_name.to_s) || super
          end

          # rubocop:disable Metrics/CyclomaticComplexity
          # rubocop:disable Metrics/PerceivedComplexity
          # Convert the fields to a string representation.
          # @param original_indent [Integer, nil] Optional indentation level.
          # @return [String] String representation of all fields.
          def to_s(original_indent = nil)
            indent = indent.nil? ? 0 : original_indent
            return '' if empty?

            indent ||= @indent_level
            padding = '  ' * indent
            lines = []

            each do |field_key, field_value|
              line = "#{padding}:#{field_key}:"

              case field_value.class.name.split('::').last
              when 'ListField'
                # Check if ListField has items and they're not empty
                if defined?(field_value.items) && field_value.items && !field_value.items.empty?
                  line += field_value.to_s
                end
              when 'ObjectField'
                line += field_value.to_s
              when 'SimpleField'
                # Check if SimpleField has a non-empty value
                if defined?(field_value.value) && field_value.value && !field_value.value.to_s.empty?
                  line += " #{field_value.value}"
                end
              else
                logger.debug("Unknown value was passed to the field creator: #{field_key} : #{field_value}")
              end

              lines << line
            end

            lines.join("\n").rstrip
          end
          # rubocop:enable Metrics/CyclomaticComplexity
          # rubocop:enable Metrics/PerceivedComplexity
        end
      end
    end
  end
end
