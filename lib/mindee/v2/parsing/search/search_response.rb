# frozen_string_literal: true

module Mindee
  module V2
    module Parsing
      module Search
        # Models search response.
        class SearchResponse < CommonResponse
          # @return [Search::SearchModels] Parsed search payload.
          attr_reader :models
          # @return [Search::Pagination] Pagination metadata.
          attr_reader :pagination

          def initialize(server_response)
            super

            @models = SearchModels.new(server_response['models'])
            @pagination = Pagination.new(server_response['pagination'])
          end

          # String representation.
          # @return [String]
          def to_s
            [
              'Models',
              '######',
              @models.to_s,
              'Pagination Metadata',
              '###################',
              @pagination.to_s,
              '',
            ].join("\n")
          end
        end
      end
    end
  end
end
