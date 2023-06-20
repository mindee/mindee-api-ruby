# frozen_string_literal: true

require_relative 'id_card_v1_page'

module Mindee
  module Product
    module FR
      # Carte Nationale d'Identité v1 prediction results.
      class IdCardV1 < IdCardV1Page
        @endpoint_name = 'idcard_fr'
        @endpoint_version = '1'

        class << self
          attr_reader :endpoint_name, :endpoint_version
        end
      end
    end
  end
end
