# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module EU
      module LicensePlate
        # License Plate V1 document prediction.
        class LicensePlateV1Document < Mindee::Parsing::Common::Prediction
          include Mindee::Parsing::Common
          include Mindee::Parsing::Standard
          # List of all license plates found in the image.
          # @return [Array<Mindee::Parsing::Standard::TextField>]
          attr_reader :license_plates

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super()
            @license_plates = []
            prediction['license_plates'].each do |item|
              @license_plates.push(TextField.new(item, page_id))
            end
          end

          def to_s
            license_plates = @license_plates.join("\n #{' ' * 16}")
            out_str = String.new
            out_str << "\n:License Plates: #{license_plates}".rstrip
            out_str[1..].to_s
          end
        end
      end
    end
  end
end
