# frozen_string_literal: true

require_relative '../../standard/position_field'

module Mindee
  module Parsing
    module Common
      module Extras
        # Contains information on the cropping of a prediction.
        class CropperExtra
          # Cropper extra initialization.
          # @return [Array<Mindee::Parsing::Standard::PositionField>]
          attr_reader :croppings

          def initialize(raw_prediction, page_id = nil)
            @croppings = [] # : Array[Mindee::Parsing::Standard::PositionField]
            raw_prediction['cropping']&.each do |crop|
              @croppings.push(Mindee::Parsing::Standard::PositionField.new(crop, page_id))
            end
          end

          # @return [String]
          def to_s
            @croppings.map(&:to_s).join("\n           ")
          end
        end
      end
    end
  end
end
