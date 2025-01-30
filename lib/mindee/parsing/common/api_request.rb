# frozen_string_literal: true

module Mindee
  module Parsing
    module Common
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
    end
  end
end
