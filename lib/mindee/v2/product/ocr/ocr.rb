# frozen_string_literal: true

require_relative 'ocr_response'
require_relative 'params/ocr_parameters'

module Mindee
  module V2
    module Product
      # OCR module.
      module OCR
        # OCR product.
        class OCR < BaseProduct
          @slug = 'ocr'
          @parameters_class = Mindee::V2::Product::OCR::Params::OCRParameters
          @response_class = Mindee::V2::Product::OCR::OCRResponse
        end
      end
    end
  end
end
