# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'international_id_v2_document'
require_relative 'international_id_v2_page'

module Mindee
  module Product
    # International ID module.
    module InternationalId
      # International ID API version 2 inference prediction.
      class InternationalIdV2 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'international_id'
        @endpoint_version = '2'
        @has_async = true
        @has_sync = false

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = InternationalIdV2Document.new(prediction['prediction'], nil)
          @pages = []
          prediction['pages'].each do |page|
            @pages.push(InternationalIdV2Page.new(page))
          end
        end

        class << self
          # Name of the endpoint for this product.
          # @return [String]
          attr_reader :endpoint_name
          # Version for this product.
          # @return [String]
          attr_reader :endpoint_version
          # Whether this product has access to an asynchronous endpoint.
          # @return [Boolean]
          attr_reader :has_async
          # Whether this product has access to synchronous endpoint.
          # @return [Boolean]
          attr_reader :has_sync
        end
      end
    end
  end
end
