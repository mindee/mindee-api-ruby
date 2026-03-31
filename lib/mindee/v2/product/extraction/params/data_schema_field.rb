# frozen_string_literal: true

module Mindee
  module V2
    module Product
      module Extraction
        module Params
          # Data Schema Field.
          class DataSchemaField
            # @return [String] Display name for the field, also impacts inference results.
            attr_reader :title
            # @return [String] Name of the field in the data schema.
            attr_reader :name
            # @return [Boolean] Whether this field can contain multiple values.
            attr_reader :is_array
            # @return [String] Data type of the field.
            attr_reader :type
            # @return [Array<String>, nil] Allowed values when type is `classification`. Leave empty for other types.
            attr_reader :classification_values
            # @return [Boolean, nil] Whether to remove duplicate values in the array.
            # Only applicable if `is_array` is True.
            attr_reader :unique_values
            # @return [String, nil] Detailed description of what this field represents.
            attr_reader :description
            # @return [String, nil] Optional extraction guidelines.
            attr_reader :guidelines
            # @return [Array<Hash>, nil] Nested fields.
            attr_reader :nested_fields

            # @param field [Hash]
            def initialize(field)
              field.transform_keys!(&:to_sym)
              @name = field[:name]
              @title = field[:title]
              @is_array = field[:is_array]
              @type = field[:type]
              @classification_values = field[:classification_values]
              @unique_values = field[:unique_values]
              @description = field[:description]
              @guidelines = field[:guidelines]
              @nested_fields = field[:nested_fields]
            end

            # @return [Hash]
            def to_hash
              out = {
                name: @name,
                title: @title,
                is_array: @is_array,
                type: @type,
              } # @type var out: Hash[Symbol, untyped]
              out[:classification_values] = @classification_values unless @classification_values.nil?
              out[:unique_values] = @unique_values unless @unique_values.nil?
              out[:description] = @description unless @description.nil?
              out[:guidelines] = @guidelines unless @guidelines.nil?
              out[:nested_fields] = @nested_fields unless @nested_fields.nil?
              out
            end

            # @return [String]
            def to_s
              to_hash.to_json
            end
          end
        end
      end
    end
  end
end
