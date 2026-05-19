# frozen_string_literal: true

require_relative 'model_webhook'

module Mindee
  module V2
    module Parsing
      module Search
        # Individual model information.
        class SearchModel
          # @return [String] ID of the model.
          attr_reader :id

          # @return [String] Name of the model.
          attr_reader :name

          # @return [String] Type of the model.
          attr_reader :model_type

          # @return [Array<ModelWebhook>] List of webhooks associated with the model.
          attr_reader :webhooks

          # @param payload [Hash] The parsed JSON payload mapping to the search model.
          def initialize(payload)
            @id = payload['id']
            @name = payload['name']
            @model_type = payload['model_type']
            @webhooks = (payload['webhooks'] || []).map { |w| ModelWebhook.new(w) }
          end

          # String representation of the model.
          # @return [String]
          def to_s
            [
              ":Name: #{@name}",
              ":ID: #{@id}",
              ":Model Type: #{@model_type}",
              ":Webhooks: #{@webhooks.join("\n")}",
            ].join("\n")
          end
        end
      end
    end
  end
end
