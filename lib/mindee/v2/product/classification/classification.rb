# frozen_string_literal: true

require_relative 'classification_response'
require_relative 'params/classification_parameters'

module Mindee
  module V2
    module Product
      module Classification
        # Classification product.
        class Classification < BaseProduct
          @slug = 'classification'
          @params_type = Mindee::V2::Product::Classification::Params::ClassificationParameters
          @response_type = Mindee::V2::Product::Classification::ClassificationResponse
        end
      end
    end
  end
end
