# frozen_string_literal: true

require 'json'
require_relative 'annotated_base_field'
require_relative 'annotated_object_field'
require_relative 'annotated_simple_field'

module Mindee
  module V2
    module Product
      module Extraction
        module RagDocuments
          # Field having a list of fields.
          class AnnotatedListField < AnnotatedBaseField
            # Items contained in the list.
            # @return [Array[AnnotatedListField | AnnotatedObjectField | AnnotatedSimpleField]]
            attr_accessor :items

            # Default constructor.
            # @param server_response [Hash[String | Symbol, untyped]]
            def initialize(server_response)
              super(server_response['selected'], server_response['guidelines'])

              unless server_response.key?('items') && server_response['items'].is_a?(Array)
                raise Error::MindeeError,
                      "Expected \"items\" to be an array in #{server_response.to_json}."
              end

              @items = server_response['items'].map do |item|
                AnnotatedBaseField.create_annotated_field(item)
              end
            end

            # Converts the list field to a Hash.
            # @return [Hash[String, untyped]]
            def to_h
              super.merge('items' => @items.map(&:to_h))
            end

            # AnnotatedSimpleField items from the list.
            # @return [Array[AnnotatedSimpleField]]
            def simple_items
              fields = [] # @type var fields: Array[AnnotatedSimpleField]
              @items.each do |item|
                raise TypeError, "Invalid field type detected: #{item.class}" unless item.is_a?(AnnotatedSimpleField)

                fields << item
              end
              fields
            end

            # AnnotatedObjectField items from the list.
            # @return [Array[AnnotatedObjectField]]
            def object_items
              fields = [] # @type var fields: Array[AnnotatedObjectField]
              @items.each do |item|
                raise TypeError, "Invalid field type detected: #{item.class}" unless item.is_a?(AnnotatedObjectField)

                fields << item
              end
              fields
            end
          end
        end
      end
    end
  end
end
