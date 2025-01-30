# frozen_string_literal: true

require_relative 'document'
require_relative '../../logging'

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

        # @param product_class [Mindee::Inference]
        # @param http_response [Hash]
        # @param raw_http [String]
        def initialize(product_class, http_response, raw_http)
          logger.debug('Handling API response')
          @raw_http = raw_http.to_s
          raise Errors::MindeeAPIError, 'Invalid response format.' unless http_response.key?('api_request')

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
