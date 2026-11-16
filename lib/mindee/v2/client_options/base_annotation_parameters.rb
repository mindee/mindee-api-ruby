# frozen_string_literal: true

module Mindee
  module V2
    module ClientOptions
      # Base parameters for document annotations.
      class BaseAnnotationParameters
        # UUID of the annotated document.
        # @return [String]
        attr_reader :document_id

        # Default constructor.
        # @param document_id [String] UUID of the annotated document.
        def initialize(document_id)
          trimmed_id = document_id&.strip
          raise Error::MindeeError, 'Document ID must be provided' if trimmed_id.nil? || trimmed_id.empty?

          # NOTE: document_id is included in the request URL path, it is not a parameter.
          @document_id = trimmed_id
        end

        # Gets the request parameters for the upload request.
        # @return [Hash[String, String]]
        def request_parameters
          raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
        end
      end
    end
  end
end
