# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'id_card_v1_document'
require_relative 'id_card_v1_page'

module Mindee
  module Product
    module FR
      module IdCard
        # French National ID Card V1 prediction inference.
        class IdCardV1 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'idcard_fr'
          @endpoint_version = '1'

          def initialize(http_response)
            super
            @prediction = IdCardV1Document.new(http_response['prediction'], nil)
            @pages = []
            http_response['pages'].each do |page|
              @pages.push(IdCardV1Page.new(page))
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
