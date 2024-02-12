# frozen_string_literal: true

require_relative 'generated_v1_document'
require_relative 'generated_v1_page'

module Mindee
  module Product
    # Generated product module.
    module Generated
      # Generated Document V1 prediction inference.
      class GeneratedV1 < Mindee::Parsing::Common::Inference
        @endpoint_name = ''
        @endpoint_version = ''

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = GeneratedV1Document.new(prediction['prediction'])
          @pages = []
          prediction['pages'].each do |page|
            @pages.push(GeneratedV1Page.new(page))
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
