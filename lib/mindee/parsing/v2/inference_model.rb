# frozen_string_literal: true

module Mindee
  module Parsing
    module V2
      # ID of the model that produced the inference.
      class InferenceModel
        # @return [String] Identifier of the model.
        attr_reader :id

        # @param server_response [Hash] Raw JSON parsed into a Hash.
        def initialize(server_response)
          @id = server_response['id']
        end
      end
    end
  end
end
