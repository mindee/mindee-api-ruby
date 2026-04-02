# frozen_string_literal: true

require_relative 'extraction_response'
require_relative 'params/extraction_parameters'

module Mindee
  module V2
    module Product
      # Extraction module.
      module Extraction
        # Extraction product.
        # Note: currently a placeholder for the `Inference` class.
        class Extraction < Product::BaseProduct
          @slug = 'extraction'
          @params_type = Product::Extraction::Params::ExtractionParameters
          @response_type = Product::Extraction::ExtractionResponse
        end
      end
    end
  end
end
