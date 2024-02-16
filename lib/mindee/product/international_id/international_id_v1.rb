# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'international_id_v1_document'
require_relative 'international_id_v1_page'

module Mindee
  module Product
    # International ID module.
    module InternationalId
      # International ID V1 prediction inference.
      class InternationalIdV1 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'international_id'
        @endpoint_version = '1'

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = InternationalIdV1Document.new(prediction['prediction'], nil)
          @pages = []
          prediction['pages'].each do |page|
            if page.key?('prediction') && !page['prediction'].nil? && !page['prediction'].empty?
              @pages.push(InternationalIdV1Page.new(page))
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
