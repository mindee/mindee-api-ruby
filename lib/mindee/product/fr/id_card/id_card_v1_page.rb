# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'id_card_v1_document'

module Mindee
  module Product
    module FR
      module IdCard
        # Carte Nationale d'Identité API version 1.1 page data.
        class IdCardV1Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = IdCardV1PagePrediction.new(
              prediction['prediction'],
              prediction['id']
            )
          end
        end

        # Carte Nationale d'Identité V1 page prediction.
        class IdCardV1PagePrediction < IdCardV1Document
          include Mindee::Parsing::Standard

          # The side of the document which is visible.
          # @return [Mindee::Parsing::Standard::ClassificationField]
          attr_reader :document_side

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            @document_side = ClassificationField.new(prediction['document_side'], page_id)
            super
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
