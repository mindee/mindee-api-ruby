# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'delivery_note_v1_document'
require_relative 'delivery_note_v1_page'

module Mindee
  module Product
    # Delivery note module.
    module DeliveryNote
      # Delivery note API version 1 inference prediction.
      class DeliveryNoteV1 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'delivery_notes'
        @endpoint_version = '1'

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = DeliveryNoteV1Document.new(prediction['prediction'], nil)
          @pages = []
          prediction['pages'].each do |page|
            if page.key?('prediction') && !page['prediction'].nil? && !page['prediction'].empty?
              @pages.push(DeliveryNoteV1Page.new(page))
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
