# frozen_string_literal: true

module Mindee
  module V2
    module Search
      module Models
        # Models search response.
        class ModelSearchResponse < Mindee::V2::Parsing::Search::BaseSearchResponse
          # @return [Mindee::V2::Parsing::Search::SearchModels] Paginated list of matching models.
          attr_reader :models

          # @param raw_response [Hash] The parsed JSON payload from the API.
          def initialize(raw_response)
            super

            @models = Mindee::V2::Parsing::Search::SearchModels.new(raw_response['models'])
          end

          # Lines composing the response-specific body (header + items).
          # @return [Array<String>]
          def body_lines
            ['Models', '######', @models.to_s]
          end
        end
      end
    end
  end
end
