# frozen_string_literal: true

module Mindee
  module V2
    module ClientOptions
      # Base parameters for searches
      class BaseSearchParameters < BaseParameters
        # @return [Integer, nil] 1-based page index.
        attr_reader :page
        # @return [Integer, nil] Number of items per page.
        attr_reader :per_page

        # @param page [Integer, nil] 1-based page index.
        # @param per_page [Integer, nil] Number of items per page.
        # rubocop:disable-next Lint/MissingSuper
        def initialize(page: nil, per_page: nil)
          @page = page
          @per_page = per_page
        end

        # Return the parameters for the request.
        # @return [Hash{String => String, Array<String>}]
        def request_parameters
          params = {} # : Hash[String, String | Array[String]]
          params['page'] = @page.to_s unless @page.nil?
          params['per_page'] = @per_page.to_s unless @per_page.nil?
          params
        end

        # @return [String] Slug of searchable resources.
        def self.slug
          raise NotImplementedError, 'Subclasses must implement the `slug` class method'
        end

        # @return [String] Slug of searchable resources.
        def slug
          self.class.slug
        end

        # @return [Class<Mindee::V2::Parsing::Search::SearchResponse>] Response class for the search.
        def self.response_class
          raise NotImplementedError, 'Subclasses must implement the `response_class` class method'
        end

        # @return [Class<Mindee::V2::Parsing::Search::SearchResponse>] Response class for the search.
        def response_class
          self.class.response_class
        end
      end
    end
  end
end
