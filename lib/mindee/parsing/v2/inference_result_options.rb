# frozen_string_literal: true

require_relative 'raw_text'

module Mindee
  module Parsing
    module V2
      # Optional data returned alongside an inference.
      class InferenceResultOptions
        # @return [Array<RawText>] Collection of raw texts per page.
        attr_reader :raw_texts

        # @param server_response [Hash] Raw JSON parsed into a Hash.
        def initialize(server_response)
          raw = server_response['raw_texts']
          @raw_texts = raw.is_a?(Array) ? raw.map { |rt| RawText.new(rt) } : []
        end
      end
    end
  end
end
