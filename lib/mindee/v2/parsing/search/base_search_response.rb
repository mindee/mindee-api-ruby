# frozen_string_literal: true

module Mindee
  module V2
    module Parsing
      module Search
        # Base class for search responses.
        class BaseSearchResponse < CommonResponse
          # Pagination metadata for the search results.
          # @return [Mindee::V2::Parsing::Search::PaginationMetadata]
          attr_reader :pagination

          def initialize(http_response)
            super

            @pagination = PaginationMetadata.new(http_response['pagination'])
          end

          # List of strings representing the search response.
          def body_lines
            raise NotImplementedError, 'body_lines must be implemented in subclasses'
          end

          # @deprecated Use {#pagination} instead.
          def pagination_metadata
            pagination
          end

          # String representation of the search response.
          # @return [String]
          def to_s
            lines = body_lines
            lines.push('Pagination Metadata')
            lines.push('###################')
            lines.push(@pagination.to_s)

            lines.join("\n")
          end
        end
      end
    end
  end
end
