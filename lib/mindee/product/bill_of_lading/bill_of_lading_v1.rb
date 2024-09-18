# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'bill_of_lading_v1_document'
require_relative 'bill_of_lading_v1_page'

module Mindee
  module Product
    # Bill of Lading module.
    module BillOfLading
      # Bill of Lading API version 1 inference prediction.
      class BillOfLadingV1 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'bill_of_lading'
        @endpoint_version = '1'

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = BillOfLadingV1Document.new(prediction['prediction'], nil)
          @pages = []
          prediction['pages'].each do |page|
            if page.key?('prediction') && !page['prediction'].nil? && !page['prediction'].empty?
              @pages.push(BillOfLadingV1Page.new(page))
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
