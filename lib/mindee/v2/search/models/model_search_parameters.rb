# frozen_string_literal: true

module Mindee
  module V2
    module Search
      module Models
        # Search for models within the organization linked to the API key.
        # All search filters are optional.
        # If no search filters are given, all models belonging to the organization are returned.
        # Results are paginated.
        class ModelSearchParameters < Mindee::V2::ClientOptions::BaseSearchParameters
          # @return [String, nil] Filter models by partial name match, case-insensitive.
          attr_reader :name

          # @return [String, nil] Filter by an exact model type.
          attr_reader :model_type

          # @param name [String, nil] Filter models by partial name match, case-insensitive.
          # @param model_type [String, nil] Filter by an exact model type.
          # @param page [Integer, nil] 1-based page index.
          # @param per_page [Integer, nil] Number of items per page.
          def initialize(name: nil, model_type: nil, page: nil, per_page: nil)
            super(page: page, per_page: per_page)
            @name = name
            @model_type = model_type
          end

          # @return [String] Slug of searchable resources.
          def self.slug
            'models'
          end

          # @return [Class<Mindee::V2::Search::Models::ModelSearchResponse>] Response class for the search.
          def self.response_class
            ModelSearchResponse
          end

          # Gets the request parameters for the search request.
          # @return [Hash{Symbol => String, Array<String>}]
          def request_parameters
            params = super

            name = @name
            model_type = @model_type
            params[:name] = name unless name.nil?
            params[:model_type] = model_type unless model_type.nil?

            params
          end
        end
      end
    end
  end
end
