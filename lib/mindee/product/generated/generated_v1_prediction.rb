# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module Generated
      # Generated Document V1 page.
      class GeneratedV1Prediction < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Common
        include Mindee::Parsing::Standard
        include Mindee::Parsing::Generated
        # All value fields in the document
        # @return [Hash<Symbol, Mindee::Parsing::Generated::GeneratedListField>]
        attr_reader :fields

        def initialize
          super
          @fields = {}
        end

        # String representation.
        def to_s
          out_str = ''
          pattern = %r{^(\n* *)( {2}):}
          @fields.each do |field_name, field_value|
            str_value = if field_value.is_a?(GeneratedListField) && field_value.values.length.positive?
                          generate_field_string(field_name, field_value, pattern)
                        else
                          field_value.to_s
                        end
            out_str += "\n:#{field_name}:"

            out_str += " #{str_value}".sub(%r{^\s+\n}, "\n") if str_value.length.positive?
          end
          out_str.sub("\n", '')
        end

        private

        def generate_field_string(field_name, field_value, pattern)
          return '' if field_value.values.empty? || field_value.values.nil?

          str_value = ''
          str_value += if field_value.values[0].is_a?(Parsing::Generated::GeneratedObjectField)
                         field_value.values[0].str_level(1).sub(pattern, '\\1* :')
                       else
                         "#{field_value.values[0].to_s.sub(pattern, '\\1* :')}\n"
                       end
          field_value.values[1..].each do |sub_value|
            str_value += if sub_value.is_a?(Parsing::Generated::GeneratedObjectField)
                           sub_value.str_level(1).sub(pattern, '\\1* :')
                         else
                           "#{' ' * (field_name.length + 2)} #{sub_value}\n"
                         end
          end
          str_value.rstrip
        end

        def generate_list_field_string(field_name, field_value, pattern)
          str_value = ''
          field_value.each_value do |sub_value|
            str_value += generate_sub_value_string(field_name, sub_value, pattern)
          end
          str_value.rstrip
        end

        def generate_sub_value_string(field_name, sub_value, pattern)
          if sub_value.is_a?(GeneratedObjectField)
            sub_value.str_level(1).gsub(pattern, '\1* :')
          else
            (' ' * (field_name.length + 2)) + "#{sub_value}\n"
          end
        end

        # Returns a hash of all fields that aren't a collection
        # @return [Hash<String, StringField>]
        def single_fields
          single_fields = {}
          @fields.each do |field_name, field_value|
            single_fields[field_name] = field_value if field_value.is_a?(StringField)
          end
          single_fields
        end

        # Returns a hash of all list-like fields
        # @return [Hash<String, GeneratedListField>]
        def list_fields
          list_fields = {}
          @fields.each do |field_name, field_value|
            list_fields[field_name] = field_value if field_value.is_a?(GeneratedListField)
          end
          list_fields
        end

        # Returns a hash of all object-like fields
        # @return [Hash<String, GeneratedObjectField>]
        def object_fields
          object_fields = {}
          @fields.each do |field_name, field_value|
            object_fields[field_name] = field_value if field_value.is_a?(GeneratedObjectField)
          end
          object_fields
        end

        # Lists names of all top-level field keys
        # @return [Array<String>]
        def list_field_names
          @fields.keys.map(&:to_s)
        end
      end
    end
  end
end
