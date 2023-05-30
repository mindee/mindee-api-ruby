# frozen_string_literal: true

module Mindee

  module REQUESTSTATUS # TODO: check if frozen hash might not be a better implementation
    FAILURE = 'failure'
    SUCCESS = 'success'
  end

  class Job
    # @return [String] Mindee ID of the document
    attr_reader :id
    # @return [Mindee::DateField]
    attr_reader :issued_at
    # @return [Mindee::DateField, nil]
    attr_reader :available_at
    # @return [Integer]
    attr_reader :available_at

    # @param http_response [Hash]
    def initialize(http_response)
      @issued_at = DateField.new(http_response['issued_at']) # check second arg in case of issue
      @available_at = DateField.new(http_response['available_at']) unless !http_response.key?('available_at')
    end
  end

  class ApiRequest

    # @return [Hash]
    attr_reader :error
    # @return [Array<String>]
    attr_reader :ressources
    # @return [String]
    attr_reader :status
    # @return [Integer]
    attr_reader :status_code
    #@ url: [String]
    attr_reader :url

    def initialize(server_response)
      @error = server_response['error']
      @ressources = server_response['ressources']
      @status = server_response['status']
      @status_code = server_response['status_code']
      @url = server_response['url']
    end
  end  

  class ApiResponse
    # @return [Mindee::DocumentResponse, nil]
    attr_reader :document
    # @return [Mindee::Job, nil]
    attr_reader :job
    # @return [Mindee::REQUESTSTATUS]
    attr_reader :api_request

    # @param prediction_class [Class<Mindee::Prediction::Prediction>]
    # @param http_response [Hash]
    def initialize(prediction_class, http_response)
      if http_response.key?('document') && (!http_response.key?('job') || http_response['job']['status']=='completed')
        @document = Mindee.Document.new(prediction_class, http_response['document'])
      end
      @job = Mindee.Job.new(http_response['job']) unless !http_response.key?('job')
    end
  end
end