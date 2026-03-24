# frozen_string_literal: true

require 'json'

module Mindee
  module V2
    module Parsing
      # Base class for inference and job responses on the V2 API.
      class CommonResponse
        # @return [String]
        attr_reader :raw_http

        # @param http_response [Hash]
        def initialize(http_response)
          @raw_http = JSON.generate(http_response)
        end
      end
    end
  end
end
