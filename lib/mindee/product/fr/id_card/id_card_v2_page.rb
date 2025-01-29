# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'id_card_v2_document'

module Mindee
  module Product
    module FR
      module IdCard
        # Carte Nationale d'Identité API version 2.0 page data.
        class IdCardV2Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = if prediction['prediction'].empty?
                            nil
                          else
                            IdCardV2PagePrediction.new(
                              prediction['prediction'],
                              prediction['id']
                            )
                          end
          end
        end

        # Carte Nationale d'Identité V2 page prediction.
        class IdCardV2PagePrediction < IdCardV2Document
          include Mindee::Parsing::Standard

          # The sides of the document which are visible.
          # @return [Mindee::Parsing::Standard::ClassificationField]
          attr_reader :document_side
          # The document type or format.
          # @return [Mindee::Parsing::Standard::ClassificationField]
          attr_reader :document_type

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            @document_side = ClassificationField.new(prediction['document_side'], page_id)
            @document_type = ClassificationField.new(prediction['document_type'], page_id)
            super
          end

          # @return [String]
          def to_s
            out_str = String.new
            out_str << "\n:Document Type: #{@document_type}".rstrip
            out_str << "\n:Document Sides: #{@document_side}".rstrip
            out_str << "\n#{super}"
            out_str
          end
        end
      end
    end
  end
end
