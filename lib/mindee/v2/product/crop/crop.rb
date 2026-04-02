# frozen_string_literal: true

require_relative 'crop_response'
require_relative 'params/crop_parameters'

module Mindee
  module V2
    module Product
      # Crop module.
      module Crop
        # Crop product.
        class Crop < BaseProduct
          @slug = 'crop'
          @params_type = Mindee::V2::Product::Crop::Params::CropParameters
          @response_type = Mindee::V2::Product::Crop::CropResponse
        end
      end
    end
  end
end
