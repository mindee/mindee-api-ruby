# frozen_string_literal: true

module Mindee
  module HTTP
    # Custom cancellation token class for polling.
    class CancellationToken
      private attr_reader :is_canceled

      def initialize
        @is_cancelled = false
      end

      # Cancel the token.
      def cancel
        @is_cancelled = true
      end

      # Check if the token is canceled.
      def canceled?
        @is_cancelled
      end
    end
  end
end
