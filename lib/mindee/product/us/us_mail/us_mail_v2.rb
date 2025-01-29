# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'us_mail_v2_document'
require_relative 'us_mail_v2_page'

module Mindee
  module Product
    module US
      # US Mail module.
      module UsMail
        # US Mail API version 2 inference prediction.
        class UsMailV2 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'us_mail'
          @endpoint_version = '2'

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = UsMailV2Document.new(prediction['prediction'], nil)
            @pages = []
            prediction['pages'].each do |page|
              @pages.push(UsMailV2Page.new(page))
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
