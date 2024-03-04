# frozen_string_literal: true

require_relative 'document'
require 'time'

module Mindee
  module Parsing
    module Common
      # Potential values for queue in asynchronous calls.
      module JobStatus
        # Document is waiting to be processed.
        WAITING = :waiting
        # Document is currently being parsed.
        PROCESSING = :processing
        # Document parsing is complete.
        COMPLETED = :completed
        # Job failed
        FAILURE = :failed
      end

      # Potential values for requests.
      module RequestStatus
        # Failed.
        FAILURE = :failure
        # Success.
        SUCCESS = :success
      end

      # Job (queue) information on async parsing.
      class Job
        # @return [String] Mindee ID of the document
        attr_reader :id
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :issued_at
        # @return [Mindee::Parsing::Standard::DateField, nil]
        attr_reader :available_at
        # @return [JobStatus, Symbol]
        attr_reader :status
        # @return [Integer, nil]
        attr_reader :millisecs_taken
        # @return [Hash, nil]
        attr_reader :error

        # @param http_response [Hash]
        def initialize(http_response)
          @id = http_response['id']
          @error = http_response['error']
          @issued_at = Time.iso8601(http_response['issued_at'])
          if http_response.key?('available_at') && !http_response['available_at'].nil?
            @available_at = Time.iso8601(http_response['available_at'])
            @millisecs_taken = (1000 * (@available_at.to_time - @issued_at.to_time).to_f).to_i
          end
          @status = case http_response['status']
                    when 'waiting'
                      JobStatus::WAITING
                    when 'processing'
                      JobStatus::PROCESSING
                    when 'completed'
                      JobStatus::COMPLETED
                    else
                      http_response['status']&.to_sym
                    end
        end
      end

      # HTTP request response.
      class ApiRequest
        # @return [Hash]
        attr_reader :error
        # @return [Array<String>]
        attr_reader :ressources
        # @return [RequestStatus, Symbol]
        attr_reader :status
        # @return [Integer]
        attr_reader :status_code
        # @return [String]
        attr_reader :url

        def initialize(server_response)
          @error = server_response['error']
          @ressources = server_response['ressources']

          @status = if server_response['status'] == 'failure'
                      RequestStatus::FAILURE
                    elsif server_response['status'] == 'success'
                      RequestStatus::SUCCESS
                    else
                      server_response['status']&.to_sym
                    end
          @status_code = server_response['status_code']
          @url = server_response['url']
        end
      end

      # Wrapper class for all predictions (synchronous and asynchronous)
      class ApiResponse
        # @return [Mindee::Parsing::Common::Document, nil]
        attr_reader :document
        # @return [Mindee::Parsing::Common::Job, nil]
        attr_reader :job
        # @return [Mindee::Parsing::Common::ApiRequest]
        attr_reader :api_request
        # @return [String]
        attr_reader :raw_http

        # @param product_class [Class<Mindee::Product>]
        # @param http_response [Hash]
        # @param raw_http [String]
        def initialize(product_class, http_response, raw_http)
          @raw_http = raw_http.to_s
          raise 'Invalid response format.' unless http_response.key?('api_request')

          @api_request = Mindee::Parsing::Common::ApiRequest.new(http_response['api_request'])

          if http_response.key?('document') &&
             (!http_response.key?('job') ||
               http_response['job']['status'] == 'completed') &&
             @api_request.status == RequestStatus::SUCCESS
            @document = Mindee::Parsing::Common::Document.new(product_class, http_response['document'])
          end
          @job = Mindee::Parsing::Common::Job.new(http_response['job']) if http_response.key?('job')
        end
      end
    end
  end
end
