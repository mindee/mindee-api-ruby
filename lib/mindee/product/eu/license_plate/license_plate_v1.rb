# frozen_string_literal: true

require_relative 'license_plate_v1_document'

module Mindee
  module Product
    module EU
      # License Plate v1 prediction results.
      class LicensePlateV1 < LicensePlateV1Document
        @endpoint_name = 'license_plates'
        @endpoint_version = '1'

        class << self
          attr_reader :endpoint_name, :endpoint_version
        end
      end
    end
  end
end
