# frozen_string_literal: true

require_relative 'base_field'

module Mindee
  module Parsing
    module V2
      module Field
        # Represents a field that contains a list of items.
        class ListField < BaseField
          # @return [Array<ListField | ObjectField | SimpleField>] Items contained in the list.
          attr_reader :items

          # @param server_response [Hash] Raw server response hash.
          # @param indent_level [Integer] Level of indentation for rst display.
          # @raise [MindeeError] If the 'items' key is missing or not an array.
          def initialize(server_response, indent_level = 0)
            super

            unless server_response.key?('items') && server_response['items'].is_a?(Array)
              raise Errors::MindeeError,
                    "Expected \"items\" to be an array in #{server_response.to_json}."
            end

            @items = []
            server_response['items'].each do |item|
              @items << BaseField.create_field(item, indent_level + 1)
            end
          end

          # Return only simple fields.
          # @return [Array<SimpleField>] Simple fields contained in the list.
          # @raise [TypeError] If the fields are not SimpleField.
          def simple_items
            fields = []
            @items.each do |item|
              raise TypeError, "Invalid field type detected: #{item.class}" unless item.is_a?(SimpleField)

              fields << item
            end
            fields
          end

          # Return only object fields.
          # @return [Array<ObjectField>] Object fields contained in the list.
          # @raise [TypeError] If the fields are not ObjectField.
          def object_items
            fields = []
            @items.each do |item|
              raise TypeError, "Invalid field type detected: #{item.class}" unless item.is_a?(ObjectField)

              fields << item
            end
            fields
          end

          # String representation of the list field.
          # @return [String] Formatted string with bullet points for each item.
          def to_s
            return '' unless @items && !@items.empty?

            parts = ['']
            @items.each do |item|
              next unless item

              parts << if item.is_a?(ObjectField)
                         item.to_s_from_list
                       else
                         item.to_s
                       end
            end

            parts.join("\n  * ")
          end
        end
      end
    end
  end
end
