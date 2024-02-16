# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'cropper_v1_document'
require_relative 'cropper_v1_page'

module Mindee
  module Product
    # Cropper module.
    module Cropper
      # Cropper V1 prediction inference.
      class CropperV1 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'cropper'
        @endpoint_version = '1'

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = CropperV1Document.new
          @pages = []
          prediction['pages'].each do |page|
            if page.key?('prediction') && !page['prediction'].nil? && !page['prediction'].empty?
              @pages.push(CropperV1Page.new(page))
            end
          end
        end

        class << self
          # Name of the endpoint for this product.
          # @return [String]
          attr_reader :endpoint_name
          # Version for this product.
          # @return [String]
          attr_reader :endpoint_version
        end
      end
    end
  end
end
