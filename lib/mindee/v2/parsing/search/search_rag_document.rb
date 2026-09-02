# frozen_string_literal: true

require 'time'

module Mindee
  module V2
    module Parsing
      module Search
        # Individual RAG document information.
        class SearchRAGDocument
          # @return [String] Unique identifier of the RAG document.
          attr_reader :id

          # @return [String] Model identifier linked to the RAG document.
          attr_reader :model_id

          # @return [String] Original filename of the uploaded document.
          attr_reader :filename

          # @return [Time] Date and time of the document creation.
          attr_reader :created_at

          # @return [Integer] Number of times this document was used in an inference.
          attr_reader :total_matches

          # @return [Time, nil] Date and time of the latest matching inference, if any.
          attr_reader :last_match_at

          # @return [String] Current status of the RAG document.
          attr_reader :status

          # @param server_response [Hash] The parsed JSON payload mapping to the RAG document.
          def initialize(server_response)
            @id = server_response['id']
            @model_id = server_response['model_id']
            @filename = server_response['filename']
            @created_at = Time.iso8601(server_response['created_at'])
            @total_matches = server_response['total_matches']
            @last_match_at = (Time.iso8601(server_response['last_match_at']) if server_response['last_match_at'])
            @status = server_response['status']
          end

          # String representation of the RAG document.
          # @return [String]
          def to_s
            [
              ":ID: #{@id}",
              ":Model ID: #{@model_id}",
              ":Filename: #{@filename}",
              ":Created At: #{@created_at}",
              ":Total Matches: #{@total_matches}",
              ":Last Match At: #{@last_match_at}",
              ":Status: #{@status}",
            ].join("\n")
          end
        end
      end
    end
  end
end
