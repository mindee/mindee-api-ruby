# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'carte_grise_v1_document'
require_relative 'carte_grise_v1_page'

module Mindee
  module Product
    module FR
      # Carte Grise module.
      module CarteGrise
        # Carte Grise V1 prediction inference.
        class CarteGriseV1 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'carte_grise'
          @endpoint_version = '1'

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = CarteGriseV1Document.new(prediction['prediction'], nil)
            @pages = []
            prediction['pages'].each do |page|
              @pages.push(CarteGriseV1Page.new(page))
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
