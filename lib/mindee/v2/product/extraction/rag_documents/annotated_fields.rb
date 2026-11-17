# frozen_string_literal: true

require_relative 'annotated_base_field'
require_relative 'annotated_list_field'
require_relative 'annotated_object_field'
require_relative 'annotated_simple_field'

module Mindee
  module V2
    module Product
      module Extraction
        module RagDocuments
          # A dictionary of field names and their corresponding configured field types.
          class AnnotatedFields < Hash
            # Default constructor.
            # @param server_response [Hash[String | Symbol, untyped]]
            def initialize(server_response)
              super()
              server_response.each do |key, value|
                self[key.to_s] = AnnotatedBaseField.create_annotated_field(value)
              end
            end

            # Returns a field as an `AnnotatedSimpleField`, or raises if the type mismatches.
            # @param field_name [String]
            # @return [AnnotatedSimpleField]
            def get_simple_field(field_name)
              field = self[field_name]
              raise KeyError, "The field '#{field_name}' was not found." if field.nil?
              unless field.is_a?(AnnotatedSimpleField)
                raise TypeError, "The field '#{field_name}' is not a AnnotatedSimpleField."
              end

              field
            end

            # Returns a field as an `AnnotatedObjectField`, or raises if the type mismatches.
            # @param field_name [String]
            # @return [AnnotatedObjectField]
            def get_object_field(field_name)
              field = self[field_name]
              raise KeyError, "The field '#{field_name}' was not found." if field.nil?
              unless field.is_a?(AnnotatedObjectField)
                raise TypeError, "The field '#{field_name}' is not an ObjectField."
              end

              field
            end

            # Returns a field as an `AnnotatedListField`, or raises if the type mismatches.
            # @param field_name [String]
            # @return [AnnotatedListField]
            def get_list_field(field_name)
              field = self[field_name]
              raise KeyError, "The field '#{field_name}' was not found." if field.nil?
              raise TypeError, "The field '#{field_name}' is not a ListField." unless field.is_a?(AnnotatedListField)

              field
            end

            # Converts the fields to a Hash.
            # @return [Hash[String, untyped]]
            def to_h
              transform_values(&:to_h)
            end
          end
        end
      end
    end
  end
end
