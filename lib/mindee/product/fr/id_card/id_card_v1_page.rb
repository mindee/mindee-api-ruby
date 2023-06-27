# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'id_card_v1_document'

module Mindee
  module Product
    module FR
      module IdCard
        # French National ID Card V1 page prediction.
        class IdCardV1Page < IdCardV1Document
          include Mindee::Parsing::Common

          # Id of the page (as given by the API).
          # @return [Integer]
          attr_reader :page_id
          # Orientation of the page.
          # @return [Mindee::Parsing::Common::Orientation]
          attr_reader :orientation
          # The side of the document which is visible.
          # @return [Mindee::Parsing::Standard::TextField]
          attr_reader :document_side

          # @param prediction [Hash]
          def initialize(prediction)
            @document_side = TextField.new(prediction['prediction']['document_side'], nil)
            @page_id = prediction['id']
            super(prediction['prediction'], @page_id)
          end

          # @return [String]
          def to_s
            out_str = String.new
            title = "Page #{@page_id}"
            out_str << "#{title}\n"
            out_str << ('-' * title.size)
            out_str << "\n:Document Side: #{@document_side}".rstrip
            out_str << "\n#{super}"
            out_str
          end
        end
      end
    end
  end
end
