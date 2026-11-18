# frozen_string_literal: true

require_relative 'annotated_base_field'
require_relative 'annotated_fields'
require_relative 'annotated_list_field'
require_relative 'annotated_simple_field'

module Mindee
  module V2
    module Product
      module Extraction
        module RagDocuments
          # Field having a set of sub-fields.
          class AnnotatedObjectField < AnnotatedBaseField
            # Nested fields carried by this object.
            # @return [AnnotatedFields]
            attr_accessor :fields

            # Default constructor.
            # @param server_response [Hash[String | Symbol, untyped]]
            def initialize(server_response)
              super(server_response['selected'], server_response['guidelines'])

              @fields = AnnotatedFields.new(server_response['fields'] || {})
            end

            # Converts the object field to a Hash.
            # @return [Hash[String, untyped]]
            def to_h
              super.merge('fields' => @fields.to_h)
            end

            # Retrieves an AnnotatedSimpleField by its name if it exists and is of the correct type.
            # @param field_name [String] The name of the field to retrieve.
            # @return [AnnotatedSimpleField]
            def get_simple_field(field_name)
              @fields.get_simple_field(field_name)
            end

            # Retrieves an AnnotatedListField by its name if it exists and is of the correct type.
            # @param field_name [String] The name of the field to retrieve.
            # @return [AnnotatedListField]
            def get_list_field(field_name)
              @fields.get_list_field(field_name)
            end

            # Retrieves an AnnotatedObjectField by its name if it exists and is of the correct type.
            # @param field_name [String] The name of the field to retrieve.
            # @return [AnnotatedObjectField]
            def get_object_field(field_name)
              @fields.get_object_field(field_name)
            end
          end
        end
      end
    end
  end
end
