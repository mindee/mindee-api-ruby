# frozen_string_literal: true

module Mindee
  module Parsing
    module Common
      # Identifier for the batch to which the execution belongs.
      class Execution
        # Identifier for the batch to which the execution belongs.
        # @return [String]
        attr_reader :batch_name
        # The time at which the execution started.
        # @return [Time, nil]
        attr_reader :created_at
        # File representation within a workflow execution.
        # @return [ExecutionFile]
        attr_reader :file
        # Identifier for the execution.
        # @return [String]
        attr_reader :id
        # Deserialized inference object.
        # @return [Mindee::Inference]
        attr_reader :inference
        # Priority of the execution.
        # @return [ExecutionPriority]
        attr_reader :priority
        # The time at which the file was tagged as reviewed.
        # @return [Time, nil]
        attr_reader :reviewed_at
        # The time at which the file was uploaded to a workflow.
        # @return [Time, nil]
        attr_reader :available_at
        # Reviewed fields and values.
        # @return [Mindee::Product::Universal::UniversalDocument]
        attr_reader :reviewed_prediction
        # Execution Status.
        # @return [String]
        attr_reader :status
        # Execution type.
        # @return [String]
        attr_reader :type
        # The time at which the file was uploaded to a workflow.
        # @return [Time, nil]
        attr_reader :uploaded_at
        # Identifier for the workflow.
        # @return [String]
        attr_reader :workflow_id

        # rubocop:disable Metrics/CyclomaticComplexity

        # @param product_class [Mindee::Inference]
        # @param http_response [Hash]
        def initialize(product_class, http_response)
          @batch_name = http_response['batch_name']
          @created_at = Time.iso8601(http_response['created_at']) if http_response['created_at']
          @file = ExecutionFile.new(http_response['file']) if http_response['file']
          @id = http_response['id']
          @inference = product_class.new(http_response['inference']) if http_response['inference']
          @priority = Mindee::Parsing::Common::ExecutionPriority.to_priority(http_response['priority'])
          @reviewed_at = Time.iso8601(http_response['reviewed_at']) if http_response['reviewed_at']
          @available_at = Time.iso8601(http_response['available_at']) if http_response['available_at']
          if http_response['reviewed_prediction']
            @reviewed_prediction = UniversalDocument.new(http_response['reviewed_prediction'])
          end
          @status = http_response['status']
          @type = http_response['type']
          @uploaded_at = Time.iso8601(http_response['uploaded_at']) if http_response['uploaded_at']
          @workflow_id = http_response['workflow_id']
        end
        # rubocop:enable Metrics/CyclomaticComplexity
      end
    end
  end
end
