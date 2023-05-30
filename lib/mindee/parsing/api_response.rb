# frozen_string_literal: true


require_relative 'document'

module Mindee

  module REQUESTSTATUS
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
    # @return [String]
    attr_reader :status
    # @return [Integer, nil]
    attr_reader :millisecs_taken

    # @param http_response [Hash]
    def initialize(http_response)
      @id = http_response['id']
      @issued_at = DateField.new(http_response['issued_at'], http_response['page_id']) # check second arg in case of issue
      if http_response.key?('available_at') && http_response['available_at'] != nil
        @available_at = DateField.new(http_response['available_at'], http_response['page_id'])
        @millisecs_taken = 1000 * (@available_at.date_object.to_f - @issued_at.date_object.to_f)
      end
      @status = http_response['status']
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
    # @return [Mindee::Document, nil]
    attr_reader :document
    # @return [Mindee::Job, nil]
    attr_reader :job
    # @return [Mindee::REQUESTSTATUS]
    attr_reader :api_request

    # @param prediction_class [Class<Mindee::Prediction::Prediction>]
    # @param http_response [Hash]
    def initialize(prediction_class, http_response)
      if http_response.key?('document') && (!http_response.key?('job') || http_response['job']['status']=='completed')
        @document = Mindee::Document.new(prediction_class, http_response['document'])
      end
      @job = Mindee::Job.new(http_response['job']) unless !http_response.key?('job')
    end
  end
end