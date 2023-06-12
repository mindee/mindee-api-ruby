# frozen_string_literal: true

require_relative 'document'
require 'time'

module Mindee
  module JobStatus
    FAILURE = 'failure'
    SUCCESS = 'success'
  end

  module RequestStatus
    FAILURE = 'failure'
    SUCCESS = 'success'
  end

  # Job (queue) information on async parsing.
  class Job
    # @return [String] Mindee ID of the document
    attr_reader :id
    # @return [Mindee::DateField]
    attr_reader :issued_at
    # @return [Mindee::DateField, nil]
    attr_reader :available_at
    # @return [JobStatus]
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
      @status = http_response['status']
    end
  end

  # HTTP request response.
  class ApiRequest
    # @return [Hash]
    attr_reader :error
    # @return [Array<String>]
    attr_reader :ressources
    # @return [RequestStatus]
    attr_reader :status
    # @return [Integer]
    attr_reader :status_code
    # @ url: [String]
    attr_reader :url

    def initialize(server_response)
      @error = server_response['error']
      @ressources = server_response['ressources']
      @status = server_response['status']
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

    # @param prediction_class [Class<Mindee::Prediction::Prediction>]
    # @param http_response [Hash]
    def initialize(prediction_class, http_response)
      if http_response.key?('document') && (!http_response.key?('job') || http_response['job']['status'] == 'completed')
        @document = Mindee::Document.new(prediction_class, http_response['document'])
      end
      @job = Mindee::Job.new(http_response['job']) if http_response.key?('job')
      @api_request = Mindee::ApiRequest.new(http_response['api_request']) if http_response.key?('api_request')
    end
  end
end
