# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'id_card_v1_document'

module Mindee
  module Product
    module FR
      # Carte Nationale d'Identité v1 prediction results.
      class IdCardV1Page < IdCardV1Document
        # The side of the document which is visible.
        # @return [Mindee::TextField]
        attr_reader :document_side

        # The identification card number.
        # @return [Mindee::TextField]

        # @param http_response [Hash]
        # @param page_id [Integer, nil]
        def initialize(http_response)
          @document_side = TextField.new(http_response['document_side'], @page_id) unless @page_id.nil? || @page_id.empty?
          @page_id = http_response['id']
          super(http_response['prediction'], @page_id)
        end

        def to_s
          out_str = String.new
          out_str << "\n:Document Side: #{@document_side}".rstrip if @document_side
          out_str << super
          out_str[1..].to_s
        end
      end
    end
  end
end
