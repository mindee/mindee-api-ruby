# frozen_string_literal: true

module Mindee
  module V2
    module Parsing
      module Search
        # Base class for search responses.
        class BaseSearchResponse < CommonResponse
          # Pagination metadata.
          # @return [Mindee::V2::Parsing::Search::PaginationMetadata]
          attr_reader :pagination

          # @param http_response [Hash] The parsed JSON payload from the API.
          def initialize(http_response)
            super

            @pagination = PaginationMetadata.new(http_response['pagination'])
          end

          # Lines composing the response-specific body (header + items).
          # @return [Array<String>]
          def body_lines
            raise NotImplementedError, 'body_lines must be implemented in subclasses'
          end

          # Pagination metadata (Obsolete).
          # @deprecated Use {#pagination} instead.
          # @return [Mindee::V2::Parsing::Search::PaginationMetadata]
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
