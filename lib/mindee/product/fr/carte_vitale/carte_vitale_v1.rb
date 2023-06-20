# frozen_string_literal: true

require_relative 'carte_vitale_v1_document'

module Mindee
  module Product
    module FR
      # Carte Vitale v1 prediction results.
      class CarteVitaleV1 < CarteVitaleV1Document
        @endpoint_name = 'carte_vitale'
        @endpoint_version = '1'

        class << self
          attr_reader :endpoint_name, :endpoint_version
        end
      end
    end
  end
end
