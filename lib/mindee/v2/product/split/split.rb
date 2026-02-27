# frozen_string_literal: true

require_relative 'split_response'
require_relative 'params/split_parameters'

module Mindee
  module V2
    module Product
      module Split
        # Split product.
        class Split < BaseProduct
          @slug = 'split'
          @params_type = Mindee::V2::Product::Split::Params::SplitParameters
          @response_type = Mindee::V2::Product::Split::SplitResponse
        end
      end
    end
  end
end
