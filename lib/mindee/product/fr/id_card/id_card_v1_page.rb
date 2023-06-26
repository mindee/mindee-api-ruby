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
          # The side of the document which is visible.
          # @return [Mindee::Parsing::Standard::TextField]
          attr_reader :document_side

          # The identification card number.
          # @return [Mindee::Parsing::Standard::TextField]

          # @param http_response [Hash]
          def initialize(http_response)
            @document_side = TextField.new(http_response['prediction']['document_side'], nil)
            @page_id = http_response['id']
            super(http_response['prediction'], @page_id)
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
