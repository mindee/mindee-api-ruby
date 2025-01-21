# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'carte_grise_v1_document'

module Mindee
  module Product
    module FR
      module CarteGrise
        # Carte Grise API version 1.1 page data.
        class CarteGriseV1Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = CarteGriseV1PagePrediction.new(
              prediction['prediction'],
              prediction['id']
            )
          end
        end

        # Carte Grise V1 page prediction.
        class CarteGriseV1PagePrediction < CarteGriseV1Document
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
