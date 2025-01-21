# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'driver_license_v1_document'

module Mindee
  module Product
    module DriverLicense
      # Driver License API version 1.0 page data.
      class DriverLicenseV1Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = DriverLicenseV1PagePrediction.new(
            prediction['prediction'],
            prediction['id']
          )
        end
      end

      # Driver License V1 page prediction.
      class DriverLicenseV1PagePrediction < DriverLicenseV1Document
        # @return [String]
        def to_s
          out_str = String.new
          out_str << "\n#{super}"
          out_str
        end
      end
    end
  end
end
