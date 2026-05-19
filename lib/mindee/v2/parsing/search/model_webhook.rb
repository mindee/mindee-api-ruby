# frozen_string_literal: true

module Mindee
  module V2
    module Parsing
      module Search
        # Individual webhook information.
        class ModelWebhook
          # @return [String] ID of the webhook.
          attr_reader :id

          # @return [String] Name of the webhook.
          attr_reader :name

          # @return [String] URL of the webhook.
          attr_reader :url

          # @param payload [Hash] The parsed JSON payload mapping to the search model.
          def initialize(payload)
            @id = payload['id']
            @name = payload['name']
            @url = payload['url']
          end

          # String representation of the model.
          # @return [String]
          def to_s
            [
              ":Name: #{@name}",
              ":ID: #{@id}",
              ":URL: #{@url}",
            ].join("\n")
          end
        end
      end
    end
  end
end
