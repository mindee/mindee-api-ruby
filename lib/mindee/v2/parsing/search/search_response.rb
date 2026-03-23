# frozen_string_literal: true

module Mindee
  module V2
    module Parsing
      module Search
        # Models search response.
        class SearchResponse < CommonResponse
          # @return [Search::Search] Parsed search payload.
          attr_reader :models
          # @return [Search::Search] Pagination metadata.
          attr_reader :pagination_metadata

          def initialize(server_response)
            super

            @models = Search::SearchModels.new(server_response['models'])
            @pagination_metadata = PaginationMetadata.new(server_response['pagination'])
          end

          def to_s
            [
              'Models',
              '######',
              models.to_s,
              'Pagination Metadata',
              '###################',
              pagination_metadata.to_s,
              '',
            ].join("\n")
          end
        end
      end
    end
  end
end
