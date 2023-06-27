# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'license_plate_v1_document'

module Mindee
  module Product
    module EU
      module LicensePlate
        class LicensePlateV1Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super(prediction)
            @prediction = LicensePlateV1PagePrediction.new(
              prediction['prediction'],
              prediction['id']
            ) 
          end
        end

        # License Plate V1 page prediction.
        class LicensePlateV1PagePrediction < LicensePlateV1Document

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super(prediction, page_id)
          end

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
end
