# frozen_string_literal: true

module Mindee
  module Input
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

    # The structure to completely replace the data schema of the model.
    class DataSchemaReplace
      # @return [Array<DataSchemaField>] Subfields when type is `nested_object`. Leave empty for other types.
      attr_reader :fields

      # @param data_schema_replace [Hash]
      def initialize(data_schema_replace)
        data_schema_replace.transform_keys!(&:to_sym)
        fields_list = data_schema_replace[:fields]
        raise Mindee::Errors::MindeeError, 'Invalid Data Schema provided.' if fields_list.nil?
        raise TypeError, 'Data Schema replacement fields cannot be empty.' if fields_list.empty?

        @fields = fields_list.map { |field| DataSchemaField.new(field) }
      end

      # @return [Hash]
      def to_hash
        { fields: @fields.map(&:to_hash) }
      end

      # @return [String]
      def to_s
        to_hash.to_json
      end
    end

    # Modify the Data Schema.
    class DataSchema
      # @return [Mindee::Input::DataSchemaReplace]
      attr_reader :replace

      # @param data_schema [Hash, String]
      def initialize(data_schema)
        case data_schema
        when String
          parsed = JSON.parse(data_schema.to_s, object_class: Hash)
          parsed.transform_keys!(&:to_sym)
          @replace = DataSchemaReplace.new(parsed[:replace])
        when Hash
          data_schema.transform_keys!(&:to_sym)
          @replace = if data_schema[:replace].is_a?(DataSchemaReplace)
                       data_schema[:replace]
                     else
                       DataSchemaReplace.new(data_schema[:replace])
                     end
        when DataSchema
          @replace = data_schema.replace
        else
          raise TypeError, 'Invalid Data Schema provided.'
        end
      end

      # @return [Hash]
      def to_hash
        { replace: @replace.to_hash }
      end

      # @return [String]
      def to_s
        to_hash.to_json
      end
    end
  end
end
