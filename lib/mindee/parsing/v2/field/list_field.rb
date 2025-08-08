# frozen_string_literal: true

require_relative 'base_field'

module Mindee
  module Parsing
    module V2
      module Field
        # Represents a field that contains a list of items.
        # The list can include various field types such as ListField, ObjectField,
        # or SimpleField. Implements the Enumerable module for traversal and
        # manipulation.
        class ListField < BaseField
          include Enumerable
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

          # String representation of the list field.
          # @return [String] Formatted string with bullet points for each item.
          def to_s
            return "\n" if @items.empty?

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

          # Check if the list is empty.
          # @return [Boolean] True if the list has no items.
          def empty?
            @items.empty?
          end

          # Get the number of items in the list.
          # @return [Integer] Number of items.
          def size
            @items.size
          end

          # Get the number of items in the list (alias for size).
          # @return [Integer] Number of items.
          def length
            @items.length
          end

          # Get an item by index.
          # @param index [Integer] The index of the item to retrieve.
          # @return [BaseField, nil] The item at the given index.
          def [](index)
            @items[index]
          end

          # Iterator for Enumerator inheritance.
          # Untyped due to incomplete support in steep.
          def each(&block)
            return to_enum(:each) unless block_given?

            @items.each(&block)
            self
          end
        end
      end
    end
  end
end
