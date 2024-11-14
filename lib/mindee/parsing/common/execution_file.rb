# frozen_string_literal: true

module Mindee
  module Parsing
    module Common
      # Representation of a workflow execution's file data.
      class ExecutionFile
        # File name.
        # @return [String]
        attr_reader :name

        # Identifier for the execution.
        # @return [String]
        attr_reader :alias

        # @param http_response [Hash]
        def initialize(http_response)
          @name = http_response['name']
          @alias = http_response['alias']
        end
      end
    end
  end
end
