# frozen_string_literal: true

module Mindee
  module HTTP
    # Custom cancellation token class for polling.
    class CancellationToken
      private attr_reader :is_canceled

      def initialize
        @is_canceled = false
      end

      # Cancel the token.
      def cancel
        @is_canceled = true
      end

      # Check if the token is canceled.
      def canceled?
        @is_canceled
      end
    end
  end
end
