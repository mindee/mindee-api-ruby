# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'id_card_v1_document'

module Mindee
  module Product
    module FR
      module IdCard
        class IdCardV1Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super(prediction)
            @prediction = IdCardV1PagePrediction.new(
              prediction['prediction'],
              prediction['id']
            )
          end
        end

        # Carte Nationale d'Identité V1 page prediction.
        class IdCardV1PagePrediction < IdCardV1Document
          include Mindee::Parsing::Common
          include Mindee::Parsing::Standard

          # Id of the page (as given by the API).
          # @return [Integer]
          attr_reader :page_id
          # Orientation of the page.
          # @return [Mindee::Parsing::Common::Orientation]
          attr_reader :document_side

          # @param prediction [Hash]
          def initialize(prediction, page_id)
            @document_side = ClassificationField.new(prediction['document_side'], page_id)
            super(prediction, page_id)
          end

          # @return [String]
          def to_s
            out_str = String.new
            out_str << "\n:Document Side: #{@document_side}".rstrip
            out_str << "\n#{super}"
            out_str
          end
        end
      end
    end
  end
end
