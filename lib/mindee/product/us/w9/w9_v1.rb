# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'w9_v1_document'
require_relative 'w9_v1_page'

module Mindee
  module Product
    module US
      # W9 module.
      module W9
        # W9 API version 1 inference prediction.
        class W9V1 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'us_w9'
          @endpoint_version = '1'

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = W9V1Document.new
            @pages = []
            prediction['pages'].each do |page|
              if page.key?('prediction') && !page['prediction'].nil? && !page['prediction'].empty?
                @pages.push(W9V1Page.new(page))
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
end
