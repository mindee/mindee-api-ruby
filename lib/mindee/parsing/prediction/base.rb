# frozen_string_literal: true

module Mindee
  module Prediction
    # Base document object.
    class Prediction
      # document type
      # @return [String]
      attr_reader :document_type
      # Validation checks for the document
      # @return [Hash<Symbol, Boolean>]
      attr_reader :checklist
      # Original filename of the document
      # @return [String, nil]
      attr_reader :filename
      # Detected MIME type of the document
      # @return [String, nil]
      attr_reader :file_mimetype
      # Endpoint name for classes
      # @return [String]
      attr_reader :endpoint_name
      # Version name for classes
      # @return [String]
      attr_reader :version

      def initialize(_prediction, _page_id)
        @checklist = {}
      end

      # @return [Boolean]
      def all_checks
        @checklist.all? { |_, value| value == true }
      end

      # Default configuration for a given document
      # @return [HTTP::StandardEndpoint]
      def self.standard_document_config(api_key)
        if !defined? @endpoint_name || !defined? @version
          raise "No default endpoint was defined for #{self.to_s}"
        end
        DocumentConfig.new(
          self.class,
          HTTP::StandardEndpoint.new(@endpoint_name, @version, api_key)
        )
      end
  
      def self.descendants
        ObjectSpace.each_object(Class).select{|klass| klass < self}
      end

    end
  end
end
