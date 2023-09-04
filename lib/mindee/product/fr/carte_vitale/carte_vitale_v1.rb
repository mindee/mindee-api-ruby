# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'carte_vitale_v1_document'
require_relative 'carte_vitale_v1_page'

module Mindee
  module Product
    module FR
      # Carte Vitale module.
      module CarteVitale
        # Carte Vitale V1 prediction inference.
        class CarteVitaleV1 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'carte_vitale'
          @endpoint_version = '1'

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = CarteVitaleV1Document.new(prediction['prediction'], nil)
            @pages = []
            prediction['pages'].each do |page|
              @pages.push(CarteVitaleV1Page.new(page))
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
