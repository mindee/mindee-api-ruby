# frozen_string_literal: true

require_relative 'mindee_error'

module Mindee
  module Error
    # Unknown HTTP error for the V2 API.
    class MindeeHTTPUnknownErrorV2 < MindeeHTTPErrorV2
      def initialize(http_error)
        super({ 'detail' => "Couldn't deserialize server error. Found: #{http_error}",
                'status' => -1,
                'title' => 'Unknown Error',
                'code' => '000-000',
                'error' => nil })
      end
    end
  end
end
