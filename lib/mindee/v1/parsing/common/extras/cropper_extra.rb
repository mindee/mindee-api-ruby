# frozen_string_literal: true

require_relative '../../standard/position_field'

module Mindee
  module V1
    module Parsing
      module Common
        module Extras
          # Contains information on the cropping of a prediction.
          class CropperExtra
            # Cropper extra initialization.
            # @return [Array<Mindee::V1::Parsing::Standard::PositionField>]
            attr_reader :croppings

            def initialize(raw_prediction, page_id = nil)
              @croppings = [] # : Array[Mindee::V1::Parsing::Standard::PositionField]
              raw_prediction['cropping']&.each do |crop|
                @croppings.push(Mindee::V1::Parsing::Standard::PositionField.new(crop, page_id))
              end
            end

            # @return [String]
            def to_s
              @croppings.join("\n           ")
            end
          end
        end
      end
    end
  end
end
