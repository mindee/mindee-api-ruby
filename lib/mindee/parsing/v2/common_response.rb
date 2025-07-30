# frozen_string_literal: true

module Mindee
  module Parsing
    module V2
      # Base class for inference and job responses on the V2 API.
      class CommonResponse
        # @return [String]
        attr_reader :raw_http

        # @param http_response [Hash]
        def initialize(http_response)
          @raw_http = http_response
        end
      end
    end
  end
end
