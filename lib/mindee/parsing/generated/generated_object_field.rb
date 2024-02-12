# frozen_string_literal: true

require_relative '../common'

module Mindee
  module Parsing
    # Generated fields and functions.
    module Generated
      # A JSON-like object, with miscellaneous values.
      class GeneratedObjectField
        include Mindee::Parsing::Standard
        attr_accessor :page_id, :confidence, :raw_value

        # Id of the page the object was found on.
        # Confidence with which the value was assessed.
        # Raw unprocessed value, as it was sent by the server.

        def initialize(raw_prediction, page_id = nil)
          @printable_values = []
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

        def str_level(level = 0)
          indent = "  #{'  ' * level}"
          out_str = ''
          @printable_values.each do |attr|
            value = instance_variable_get("@#{attr}")
            str_value = value.nil? ? '' : value.to_s
            out_str += "\n#{indent}:#{attr}: #{str_value}"
          end
          "\n#{indent}#{out_str.strip}"
        end

        def to_s
          str_level
        end

        private

        def handle_position_field(name, value, item_page_id)
          instance_variable_set(
            "@#{name}",
            PositionField.new({ name => value }, value_key: name, page_id: item_page_id)
          )
          @printable_values.push(name)
        end

        def handle_default_field(name, value)
          instance_variable_set(
            "@#{name}",
            value.nil? ? nil : value.to_s
          )
          @printable_values.push(name)
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
