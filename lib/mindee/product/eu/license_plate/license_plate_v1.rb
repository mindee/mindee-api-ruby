# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module EU
      # License Plate v1 prediction results.
      class LicensePlateV1
        @endpoint_name = 'license_plates'
        @endpoint_version = '1'

        # List of all license plates found in the image.
        # @return [Array<Mindee::TextField>]
        attr_reader :license_plates

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
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

        class << self
          attr_reader :endpoint_name, :endpoint_version
        end
      end
    end
  end
end
