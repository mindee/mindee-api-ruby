# frozen_string_literal: true

require_relative 'universal_document'
require_relative 'universal_page'

module Mindee
  module Product
    # Universal product module.
    module Universal
      # Universal Document V1 prediction inference.
      class Universal < Mindee::Parsing::Common::Inference
        @endpoint_name = ''
        @endpoint_version = ''
        @has_sync = true
        @has_async = true

        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = UniversalDocument.new(prediction['prediction'])
          @pages = [] # : Array[Mindee::Parsing::Common::Page]
          prediction['pages'].each do |page|
            if page.key?('prediction') && !page['prediction'].nil? && !page['prediction'].empty?
              @pages.push(UniversalPage.new(page))
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
          # Whether this product has access to an asynchronous endpoint.
          # @return [bool]
          attr_reader :has_async
          # Whether this product has access to synchronous endpoint.
          # @return [bool]
          attr_reader :has_sync
        end
      end
    end
  end
end
