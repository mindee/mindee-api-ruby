# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'license_plate_v1_document'
require_relative 'license_plate_v1_page'

module Mindee
  module Product
    module EU
      module LicensePlate
        # License Plate v1 prediction inference.
        class LicensePlateV1 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'license_plates'
          @endpoint_version = '1'

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = LicensePlateV1Document.new(prediction['prediction'], nil)
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
          end
        end
      end
    end
  end
end
