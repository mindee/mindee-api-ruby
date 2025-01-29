# frozen_string_literal: true

module Mindee
  module Parsing
    module Common
      # Represents the server response after a document is sent to a workflow.
      class WorkflowResponse
        # Set the prediction model used to parse the document.
        # The response object will be instantiated based on this parameter.
        # @return [Mindee::Parsing::Common::Execution]
        attr_reader :execution
        # @return [Mindee::Parsing::Common::ApiRequest]
        attr_reader :api_request
        # @return [String]
        attr_reader :raw_http

        # @param http_response [Hash]
        # @param product_class [Mindee::Inference]
        def initialize(product_class, http_response, raw_http)
          @raw_http = raw_http.to_s
          @api_request = Mindee::Parsing::Common::ApiRequest.new(http_response['api_request'])
          product_class ||= Product::Universal::Universal
          @execution = Mindee::Parsing::Common::Execution.new(product_class, http_response['execution'])
        end
      end
    end
  end
end
