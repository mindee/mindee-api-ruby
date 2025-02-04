# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'healthcare_card_v1_document'
require_relative 'healthcare_card_v1_page'

module Mindee
  module Product
    module US
      # Healthcare Card module.
      module HealthcareCard
        # Healthcare Card API version 1 inference prediction.
        class HealthcareCardV1 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'us_healthcare_cards'
          @endpoint_version = '1'
          @has_async = true
          @has_sync = false

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = HealthcareCardV1Document.new(prediction['prediction'], nil)
            @pages = []
            prediction['pages'].each do |page|
              @pages.push(HealthcareCardV1Page.new(page))
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
