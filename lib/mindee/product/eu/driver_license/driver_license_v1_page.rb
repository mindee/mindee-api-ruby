# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'driver_license_v1_document'

module Mindee
  module Product
    module EU
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
          include Mindee::Parsing::Standard

          # Has a photo of the EU driver license holder
          # @return [Mindee::Parsing::Standard::PositionField]
          attr_reader :photo
          # Has a signature of the EU driver license holder
          # @return [Mindee::Parsing::Standard::PositionField]
          attr_reader :signature

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            @photo = PositionField.new(prediction['photo'], page_id)
            @signature = PositionField.new(prediction['signature'], page_id)
            super
          end

          # @return [String]
          def to_s
            out_str = String.new
            out_str << "\n:Photo: #{@photo}".rstrip
            out_str << "\n:Signature: #{@signature}".rstrip
            out_str << "\n#{super}"
            out_str
          end
        end
      end
    end
  end
end
