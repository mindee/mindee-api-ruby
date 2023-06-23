# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'carte_vitale_v1_document'
require_relative 'carte_vitale_v1_page'

module Mindee
  module Product
    module FR
      module CarteVitale
        # Carte Vitale v1 prediction inference.
        class CarteVitaleV1 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'carte_vitale'
          @endpoint_version = '1'

          def initialize(http_response)
            super
            @prediction = CarteVitaleV1Document.new(http_response['prediction'], nil)
            @pages = []
            http_response['pages'].each do |page|
              @pages.push(CarteVitaleV1Page.new(page))
            end
          end

          class << self
            attr_reader :endpoint_name, :endpoint_version
          end
        end
      end
    end
  end
end
