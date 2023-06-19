# frozen_string_literal: true

require_relative 'document'
require 'time'

module Mindee
  module JobStatus
    WAITING = :waiting
    PROCESSING = :processing
    COMPLETED = :completed
  end

  module RequestStatus
    FAILURE = :failure
    SUCCESS = :success
  end

  module Parsing
    module Common
      # Job (queue) information on async parsing.
      class Job
        # @return [String] Mindee ID of the document
        attr_reader :id
        # @return [Mindee::DateField]
        attr_reader :issued_at
        # @return [Mindee::DateField, nil]
        attr_reader :available_at
        # @return [JobStatus, Symbol]
        attr_reader :status
        # @return [Integer, nil]
        attr_reader :millisecs_taken

        # @param http_response [Hash]
        def initialize(http_response)
          @id = http_response['id']
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
        # @ url: [String]
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
        # @return [Mindee::Document, nil]
        attr_reader :document
        # @return [Mindee::Job, nil]
        attr_reader :job
        # @return [Mindee::ApiRequest]
        attr_reader :api_request

        # @param product_class [Class<Mindee::Product>]
        # @param http_response [Hash]
        def initialize(product_class, http_response)
          @api_request = Mindee::ApiRequest.new(http_response['api_request']) if http_response.key?('api_request')
          if http_response.key?('document') &&
             (!http_response.key?('job') ||
             http_response['job']['status'] == 'completed') &&
             @api_request.status == RequestStatus::SUCCESS
            @document = Mindee::Document.new(product_class, http_response['document'])
          end
          @job = Mindee::Job.new(http_response['job']) if http_response.key?('job')
        end
      end
    end
  end

  class ApiResponse < Mindee::Parsing::Common::ApiResponse
  end

  class ApiRequest < Mindee::Parsing::Common::ApiRequest
  end

  class Job < Mindee::Parsing::Common::Job
  end
end
