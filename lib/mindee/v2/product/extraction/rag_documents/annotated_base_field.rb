# frozen_string_literal: true

require 'json'

module Mindee
  module V2
    module Product
      module Extraction
        module RagDocuments
          # Base class for annotated fields.
          class AnnotatedBaseField
            # When true, use the RAG information for the final result. When false, use the Data Schema information.
            # @return [Boolean]
            attr_reader :selected

            # Guidelines or instructions for processing this field.
            # @return [String, nil]
            attr_reader :guidelines

            # Default constructor.
            # @param selected [Boolean, nil] When true, use the RAG information for the final result.
            #   When false, use the Data Schema information.
            # @param guidelines [String, nil] Guidelines or instructions for processing this field.
            def initialize(selected = false, guidelines = nil)
              @selected = selected.nil? ? false : selected
              @guidelines = guidelines
            end

            # Converts the field to a Hash.
            # @return [Hash[String, untyped]]
            def to_h
              {
                'selected' => @selected,
                'guidelines' => @guidelines,
              }
            end

            # Serializes the field to API JSON format.
            # @return [String]
            def to_json(state = nil)
              to_h.to_json(state)
            end

            # Factory method to create appropriate field types.
            # @param server_response [Hash] Raw prediction hash.
            # @return [AnnotatedBaseField] Appropriate field instance.
            # @raise [MindeeError] If the field type isn't recognized.
            def self.create_annotated_field(server_response)
              if server_response.key?('items')
                require_relative 'annotated_list_field'
                return AnnotatedListField.new(server_response)
              end

              if server_response.key?('fields')
                require_relative 'annotated_object_field'
                return AnnotatedObjectField.new(server_response)
              end

              if server_response.key?('value')
                require_relative 'annotated_simple_field'
                return AnnotatedSimpleField.new(server_response)
              end

              raise Error::MindeeError, "Unrecognized field format in #{server_response.to_json}"
            end
          end
        end
      end
    end
  end
end
