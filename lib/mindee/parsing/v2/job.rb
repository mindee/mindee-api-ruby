# frozen_string_literal: true

require 'date'
require_relative 'error_response'
require_relative 'job_webhook'

module Mindee
  module Parsing
    module V2
      # Metadata returned when polling a job (asynchronous request).
      class Job
        # @return [String] Unique job identifier.
        attr_reader :id
        # @return [DateTime, nil] Timestamp of creation.
        attr_reader :created_at
        # @return [String] Identifier of the model used.
        attr_reader :model_id
        # @return [String] Name of the processed file.
        attr_reader :filename
        # @return [String] Optional alias for the file.
        attr_reader :alias
        # @return [String, nil] Current status (submitted, processing, done, …).
        attr_reader :status
        # @return [String] URL to query for updated status.
        attr_reader :polling_url
        # @return [String, nil] URL that redirects to the final result once ready.
        attr_reader :result_url
        # @return [Array<JobWebhook>] Webhooks triggered by the job.
        attr_reader :webhooks
        # @return [ErrorResponse, nil] Error details when the job failed.
        attr_reader :error

        # @param server_response [Hash] Parsed JSON payload from the API.
        def initialize(server_response)
          raise ArgumentError, 'server_response must be a Hash' unless server_response.is_a?(Hash)

          @id          = server_response['id']
          @status      = server_response['status'] if server_response.key?('status')
          unless server_response['error'].nil? || server_response['error'].empty?
            @error = ErrorResponse.new(server_response['error'])
          end
          @created_at  = Time.iso8601(server_response['created_at'])
          @model_id    = server_response['model_id']
          @polling_url = server_response['polling_url']
          @filename    = server_response['filename']
          @result_url  = server_response['result_url']
          @alias       = server_response['alias']
          @webhooks = []
          server_response['webhooks'].each do |webhook|
            @webhooks.push JobWebhook.new(webhook)
          end
        end

        # RST-style string representation, useful for debugging or logs.
        #
        # @return [String]
        def to_s
          lines = [
            'Job',
            '###',
            ":ID: #{@id}",
            ":CreatedAt: #{@created_at}",
            ":ModelID: #{@model_id}",
            ":Filename: #{@filename}",
            ":Alias: #{@alias}",
            ":Status: #{@status}",
            ":PollingURL: #{@polling_url}",
            ":ResultURL: #{@result_url}",
          ]

          lines << @error.to_s if @error

          unless @webhooks.empty?
            lines += [
              '',
              'Webhooks',
              '=========',
              @webhooks.map(&:to_s).join("\n\n"),
            ]
          end

          lines.join("\n")
        end
      end
    end
  end
end
