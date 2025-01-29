# frozen_string_literal: true

require_relative '../common'

module Mindee
  module Parsing
    # Universal fields and functions.
    module Universal
      # A JSON-like object, with miscellaneous values.
      class UniversalObjectField
        include Mindee::Parsing::Standard
        attr_accessor :page_id, :confidence, :raw_value

        # ID of the page the object was found on.
        # Confidence with which the value was assessed.
        # Raw unprocessed value, as it was sent by the server.

        def initialize(raw_prediction, page_id = nil)
          @all_values = {}
          item_page_id = nil
          raw_prediction.each do |name, value|
            case name
            when 'page_id'
              item_page_id = value
            when 'polygon', 'rectangle', 'quadrangle', 'bounding_box'
              handle_position_field(name, value, item_page_id)
            when 'confidence'
              @confidence = value
            when 'raw_value'
              @raw_value = value
            else
              handle_default_field(name, value)
            end
            @page_id = page_id || item_page_id
          end
        end

        # String representation that takes into account the level of indentation.
        def str_level(level = 0)
          indent = "  #{'  ' * level}"
          out_str = ''
          @all_values.each do |attr, value|
            str_value = value.nil? ? '' : value.to_s
            out_str += "\n#{indent}:#{attr}: #{str_value}".rstrip
          end
          "\n#{indent}#{out_str.strip}"
        end

        # Necessary overload of the method_missing method to allow for direct access to dynamic attributes without
        # complicating usage too much
        # Returns the corresponding attribute when asked.
        #
        # Otherwise, raises a NoMethodError.
        #
        # @param method_name [Symbol] The name of the method being called.
        # @param _args [Array] Arguments passed to the method.
        # @return [Object] The value associated with the method name in @all_values.
        def method_missing(method_name, *_args)
          super unless @all_values.key?(method_name.to_s)
          @all_values[method_name.to_s]
        end

        # Necessary overload of the respond_to_missing? method to allow for direct access to dynamic attributes without
        # complicating usage too much
        # Returns true if the method name exists as a key in @all_values,
        # indicating that the object can respond to the method.
        # Otherwise, calls super to fallback to the default behavior.
        #
        # @param method_name [Symbol] The name of the method being checked.
        # @param include_private [Boolean] Whether to include private methods in the check.
        # @return [Boolean] True if the method can be responded to, false otherwise.
        def respond_to_missing?(method_name, include_private = false)
          @all_values.key?(method_name.to_s) || super
        end

        # String representation
        def to_s
          str_level
        end

        private

        def handle_position_field(name, value, item_page_id)
          @all_values[name.to_s] =
            PositionField.new({ name.to_s => value }, value_key: name.to_s, page_id: item_page_id)
        end

        def handle_default_field(name, value)
          @all_values[name] = value.nil? ? nil : value.to_s
        end
      end

      def self.generated_object?(str_dict)
        common_keys = [
          'value',
          'polygon',
          'rectangle',
          'page_id',
          'confidence',
          'quadrangle',
          'values',
          'raw_value',
        ]
        str_dict.each_key { |key| return true unless common_keys.include?(key) }
        false
      end
    end
  end
end
