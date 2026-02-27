# frozen_string_literal: true

require_relative 'ocr_response'
require_relative 'params/ocr_parameters'

module Mindee
  module V2
    module Product
      module Ocr
        # Ocr product.
        class Ocr < BaseProduct
          @slug = 'ocr'
          @params_type = Mindee::V2::Product::Ocr::Params::OcrParameters
          @response_type = Mindee::V2::Product::Ocr::OcrResponse
        end
      end
    end
  end
end
