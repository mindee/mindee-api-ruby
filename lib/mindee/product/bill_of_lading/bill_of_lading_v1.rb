# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'bill_of_lading_v1_document'
require_relative 'bill_of_lading_v1_page'

module Mindee
  module Product
    # Bill of Lading module.
    module BillOfLading
      # Bill of Lading API version 1 inference prediction.
      class BillOfLadingV1 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'bill_of_lading'
        @endpoint_version = '1'
        @has_async = true
        @has_sync = false

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = BillOfLadingV1Document.new(prediction, nil)
          @pages = []
          prediction['pages'].each do |page|
            @pages.push(BillOfLadingV1Page.new(page))
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
          # @return [bool]
          attr_reader :has_async
          # Whether this product has access to synchronous endpoint.
          # @return [bool]
          attr_reader :has_sync
        end
      end
    end
  end
end
