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

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = InternationalIdV2Document.new(prediction['prediction'], nil)
          @pages = []
          prediction['pages'].each do |page|
            if page.key?('prediction') && !page['prediction'].nil? && !page['prediction'].empty?
              @pages.push(InternationalIdV2Page.new(page))
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
