# frozen_string_literal: true

require_relative 'custom_v1_document'
require_relative 'custom_v1_page'

module Mindee
  module Product
    module Custom
      # Custom Document V1 prediction inference.
      class CustomV1 < Mindee::Parsing::Common::Inference
        @endpoint_name = ''
        @endpoint_version = ''

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = CustomV1Document.new(prediction['prediction'], nil)
          @pages = []
          prediction['pages'].each do |page|
            @pages.push(CustomV1Page.new(page))
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
