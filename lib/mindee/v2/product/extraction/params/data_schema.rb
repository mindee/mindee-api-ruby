# frozen_string_literal: true

require_relative 'data_schema_replace'

module Mindee
  module V2
    module Product
      module Extraction
        module Params
          # Modify the Data Schema.
          class DataSchema
            # @return [Mindee::V2::Product::Extraction::Params::DataSchemaReplace]
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
    end
  end
end
