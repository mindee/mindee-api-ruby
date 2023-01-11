# frozen_string_literal: true

module Mindee
  module Parsing
    # API Error
    class Error < StandardError
      # @return [String]
      attr_reader :api_code
      # @return [String]
      attr_reader :api_details
      # @return [String]
      attr_reader :api_message

      def initialize(error)
        @api_code = error['code']
        @api_details = error['details']
        @api_message = error['message']
        super("#{@api_code}: #{@api_details} - #{@api_message}")
      end
    end
  end
end
