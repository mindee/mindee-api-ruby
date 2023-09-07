# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'passport_v1_document'
require_relative 'passport_v1_page'

module Mindee
  module Product
    # Passport module.
    module Passport
      # Passport V1 prediction inference.
      class PassportV1 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'passport'
        @endpoint_version = '1'

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = PassportV1Document.new(prediction['prediction'], nil)
          @pages = []
          prediction['pages'].each do |page|
            @pages.push(PassportV1Page.new(page))
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
