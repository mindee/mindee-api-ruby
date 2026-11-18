# frozen_string_literal: true

require_relative 'annotated_base_field'

module Mindee
  module V2
    module Product
      module Extraction
        module RagDocuments
          # A SimpleField with additional configuration for annotation.
          class AnnotatedSimpleField < AnnotatedBaseField
            # Field value, one of: string, boolean, number, null.
            # @return [String, Boolean, Numeric, nil]
            attr_accessor :value

            # Default constructor.
            # @param server_response [Hash[String | Symbol, untyped]]
            def initialize(server_response)
              super(server_response['selected'], server_response['guidelines'])
              @value = server_response['value']
            end

            # Converts the simple field to a Hash.
            # @return [Hash[String, untyped]]
            def to_h
              super.merge('value' => @value)
            end
          end
        end
      end
    end
  end
end
