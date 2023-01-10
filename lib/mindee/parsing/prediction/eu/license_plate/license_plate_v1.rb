# frozen_string_literal: true

module Mindee
  module Prediction
    module EU
      # License plate prediction.
      class LicensePlateV1 < Prediction
        # @return [Array<Mindee::TextField>]
        attr_reader :license_plates

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @license_plates = []
          prediction['license_plates'].each do |item|
            @license_plates.push(TextField.new(item, page_id))
          end
        end

        def to_s
          license_plates = @license_plates.map(&:value).join(', ')
          out_str = String.new
          out_str << "\n:License plates: #{license_plates}".rstrip
          out_str[1..].to_s
        end
      end
    end
  end
end
