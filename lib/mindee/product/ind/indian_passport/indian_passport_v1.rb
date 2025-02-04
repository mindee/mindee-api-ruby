# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'indian_passport_v1_document'
require_relative 'indian_passport_v1_page'

module Mindee
  module Product
    module IND
      # Passport - India module.
      module IndianPassport
        # Passport - India API version 1 inference prediction.
        class IndianPassportV1 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'ind_passport'
          @endpoint_version = '1'
          @has_async = true
          @has_sync = false

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = IndianPassportV1Document.new(prediction['prediction'], nil)
            @pages = []
            prediction['pages'].each do |page|
              @pages.push(IndianPassportV1Page.new(page))
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
end
