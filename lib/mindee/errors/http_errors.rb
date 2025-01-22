# frozen_string_literal: true

module Errors
  # Base class for all http-related errors.
  class MindeeHTTPError < MindeeError
    # @return [Integer]
    attr_reader :status_code
    # @return [String, Nil]
    attr_reader :api_code
    # @return [Hash]
    attr_reader :api_details
    # @return [Hash]
    attr_reader :api_message
  end
end
