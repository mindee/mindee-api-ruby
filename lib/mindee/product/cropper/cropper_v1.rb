# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'cropper_v1_document'
require_relative 'cropper_v1_page'

module Mindee
  module Product
    # Cropper module.
    module Cropper
      # Cropper API version 1 inference prediction.
      class CropperV1 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'cropper'
        @endpoint_version = '1'
        @has_async = false
        @has_sync = true

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = CropperV1Document.new
          @pages = []
          prediction['pages'].each do |page|
            @pages.push(CropperV1Page.new(page))
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
