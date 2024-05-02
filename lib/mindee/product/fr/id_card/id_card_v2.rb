# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'id_card_v2_document'
require_relative 'id_card_v2_page'

module Mindee
  module Product
    module FR
      # Carte Nationale d'Identité module.
      module IdCard
        # Carte Nationale d'Identité API version 2 inference prediction.
        class IdCardV2 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'idcard_fr'
          @endpoint_version = '2'

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = IdCardV2Document.new(prediction['prediction'], nil)
            @pages = []
            prediction['pages'].each do |page|
              if page.key?('prediction') && !page['prediction'].nil? && !page['prediction'].empty?
                @pages.push(IdCardV2Page.new(page))
              end
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
