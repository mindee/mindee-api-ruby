# frozen_string_literal: true

require 'json'
require_relative 'annotated_fields'

module Mindee
  module V2
    module Product
      module Extraction
        module RagDocuments
          # A RAG annotation enriched with field-level configuration.
          class RagAnnotation
            # A dictionary of field names and their corresponding configured field types.
            # @return [AnnotatedFields]
            attr_reader :fields

            # Default constructor.
            # @param server_response [Hash[String | Symbol, untyped]]
            def initialize(server_response)
              @fields = AnnotatedFields.new(server_response['fields'] || {})
            end

            # Converts the annotation to a Hash.
            # @return [Hash[String, untyped]]
            def to_h
              { 'fields' => @fields.to_h }
            end
          end
        end
      end
    end
  end
end
