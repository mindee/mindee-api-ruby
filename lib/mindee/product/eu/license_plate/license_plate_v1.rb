# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'license_plate_v1_document'
require_relative 'license_plate_v1_page'

module Mindee
  module Product
    module EU
      # License Plate module.
      module LicensePlate
        # License Plate API version 1 inference prediction.
        class LicensePlateV1 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'license_plates'
          @endpoint_version = '1'
          @has_async = false
          @has_sync = true

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = LicensePlateV1Document.new(prediction, nil)
            @pages = []
            prediction['pages'].each do |page|
              @pages.push(LicensePlateV1Page.new(page))
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
