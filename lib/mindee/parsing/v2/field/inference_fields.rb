# frozen_string_literal: true

require_relative 'base_field'

module Mindee
  module Parsing
    module V2
      module Field
        # Represents a hash-like collection of inference fields, providing methods for
        # retrieval and string representation.
        class InferenceFields < Hash
          # @return [Integer] Level of indentation for rst display.
          attr_reader :indent_level

          # @param server_response [Hash] Raw server response hash.
          # @param indent_level [Integer] Level of indentation for rst display.
          def initialize(server_response, indent_level = 0)
            super()
            @indent_level = indent_level

            server_response.each do |key, value|
              self[key.to_s] = BaseField.create_field(value, 1)
            end
          end

          # Get a field by key with nil fallback.
          # @param key [String] Field key to retrieve.
          # @return [BaseField, nil] The field or nil if not found.
          def get(key)
            self[key]
          end

          # Get a field by key and ensure it is a SimpleField.
          # @param key [String] Field key to retrieve.
          # @return [SimpleField] The SimpleField.
          # @raise [TypeError] If the field is not a SimpleField.
          def get_simple_field(key)
            field = self[key]
            raise TypeError, "Field #{key} is not a SimpleField" unless field.is_a?(SimpleField)

            field
          end

          # Get a field by key and ensure it is a ListField.
          # @param key [String] Field key to retrieve.
          # @return [ListField] The ListField.
          # @raise [TypeError] If the field is not a ListField.
          def get_list_field(key)
            field = self[key]
            raise TypeError, "Field #{key} is not a ListField" unless field.is_a?(ListField)

            field
          end

          # Get a field by key and ensure it is an ObjectField.
          # @param key [String] Field key to retrieve.
          # @return [ObjectField] The ObjectField.
          # @raise [TypeError] If the field is not an ObjectField.
          def get_object_field(key)
            field = self[key]
            raise TypeError, "Field #{key} is not a ObjectField" unless field.is_a?(ObjectField)

            field
          end

          # rubocop:disable Metrics/CyclomaticComplexity
          # rubocop:disable Metrics/PerceivedComplexity
          # Convert the fields to a string representation.
          # @param indent [Integer, nil] Optional indentation level.
          # @return [String] String representation of all fields.
          def to_s(indent = 0)
            return '' if empty?

            indent ||= @indent_level
            padding = '  ' * indent
            lines = []

            each do |field_key, field_value|
              line = "#{padding}:#{field_key}:"

              case (field_value.class.name || '').split('::').last
              when 'ListField', 'ObjectField'
                line += field_value.to_s
              when 'SimpleField'
                # Check if SimpleField has a non-empty value
                simple_f = field_value # @type var simple_f: SimpleField
                if defined?(simple_f.value) && simple_f.value && !simple_f.value.to_s.empty?
                  line += " #{simple_f}"
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
