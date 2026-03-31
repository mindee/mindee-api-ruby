# frozen_string_literal: true

require_relative 'data_schema_field'

module Mindee
  module V2
    module Product
      module Extraction
        module Params
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
        end
      end
    end
  end
end
