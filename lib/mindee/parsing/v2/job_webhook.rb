# lib/mindee/parsing/v2/job_response_webhook.rb
# frozen_string_literal: true

require 'date'
require_relative 'error_response'

module Mindee
  module Parsing
    module V2
      # Information about a webhook created for a job response.
      class JobWebhook
        # @return [String] Identifier of the webhook.
        attr_reader :id
        # @return [DateTime, nil] Creation timestamp (or +nil+ when absent).
        attr_reader :created_at
        # @return [String] Webhook status.
        attr_reader :status
        # @return [ErrorResponse, nil] Error information when something failed.
        attr_reader :error

        # @param server_response [Hash] Raw JSON parsed into a Hash.
        def initialize(server_response)
          @id = server_response['id']
          @created_at = parse_date(server_response['created_at'])
          @status     = server_response['status']
          @error      = ErrorResponse.new(server_response['error']) if server_response.key?('error')
        end

        # RST display.
        #
        # @return [String]
        def to_s
          parts = [
            'JobResponseWebhook',
            '##################',
            ":ID: #{@id}",
            ":CreatedAt: #{@created_at}",
            ":Status: #{@status}",
          ]

          parts << @error.to_s if @error
          parts.join("\n")
        end

        private

        # Safely parse an ISO-8601 date/time string to DateTime.
        # @param str [String, nil] The date string.
        # @return [DateTime, nil]
        def parse_date(str)
          return nil if str.to_s.empty?

          DateTime.iso8601(str || '')
        rescue ArgumentError
          nil
        end
      end
    end
  end
end
