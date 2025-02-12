# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'us_mail_v3_document'
require_relative 'us_mail_v3_page'

module Mindee
  module Product
    module US
      # US Mail module.
      module UsMail
        # US Mail API version 3 inference prediction.
        class UsMailV3 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'us_mail'
          @endpoint_version = '3'
          @has_async = true
          @has_sync = false

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = UsMailV3Document.new(prediction['prediction'], nil)
            @pages = []
            prediction['pages'].each do |page|
              @pages.push(UsMailV3Page.new(page))
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
end
