# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'id_card_v1_document'
require_relative 'id_card_v1_page'

module Mindee
  module Product
    module FR
      # Carte Nationale d'Identité v1 prediction results.
      class IdCardV1 < Inference
        @endpoint_name = 'idcard_fr'
        @endpoint_version = '1'

        # @return [Array<Mindee::Product::FR::IdCardV1Page>]
        attr_reader :pages

        # @return [Mindee::Product::FR::IdCardV1Document]
        attr_reader :prediction

        def initialize(http_response)
          super
          @prediction = IdCardV1Document.new(http_response['prediction'], nil)
          @pages = []
          http_response['pages'].each do |page|
            @pages.push(IdCardV1Page.new(page))
          end
        end

        class << self
          attr_reader :endpoint_name, :endpoint_version
        end
      end
    end
  end
end
