# frozen_string_literal: true

module Mindee
  module V2
    module Parsing
      module Search
        # Pagination Metadata data associated with model search.
        class PaginationMetadata
          # @return [Integer] Number of items per page.
          attr_reader :per_page

          # @return [Integer] 1-indexed page number.
          attr_reader :page

          # @return [Integer] Total items.
          attr_reader :total_items

          # @return [Integer] Total number of pages.
          attr_reader :total_pages

          # @param raw_response [Hash] The parsed JSON payload mapping to pagination metadata.
          def initialize(raw_response)
            @per_page = raw_response['per_page']
            @page = raw_response['page']
            @total_items = raw_response['total_items']
            @total_pages = raw_response['total_pages']
          end

          # String representation of the pagination metadata.
          # @return [String]
          def to_s
            [
              ":Per Page: #{@per_page}",
              ":Page: #{@page}",
              ":Total Items: #{@total_items}",
              ":Total Pages: #{@total_pages}",
              '',
            ].join("\n")
          end
        end
      end
    end
  end
end
