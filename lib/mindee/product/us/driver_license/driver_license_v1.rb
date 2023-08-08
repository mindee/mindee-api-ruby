# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'driver_license_v1_document'
require_relative 'driver_license_v1_page'

module Mindee
  module Product
    module US
      module DriverLicense
        # Driver License V1 prediction inference.
        class DriverLicenseV1 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'us_driver_license'
          @endpoint_version = '1'

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = DriverLicenseV1Document.new(prediction['prediction'], nil)
            @pages = []
            prediction['pages'].each do |page|
              @pages.push(DriverLicenseV1Page.new(page))
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