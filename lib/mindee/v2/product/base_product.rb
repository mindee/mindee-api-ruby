# frozen_string_literal: true

require_relative '../parsing/base_response'

module Mindee
  module V2
    module Product
      # Base class for all V2 products.
      class BaseProduct
        # @return [String] The slug of the endpoint used for this response
        @slug = ''
        # @return [Class<BaseParameters>] The class of the parameters used for this response
        @params_type = Mindee::Input::BaseParameters
        # @return [Class<BaseResponse>] The class of the response used for this product
        @response_type = Mindee::V2::Parsing::BaseResponse

        def initialize
          raise StandardError, 'Cannot instantiate abstract class.' if instance_of?(BaseProduct)
        end

        class << self
          attr_reader :params_type, :slug, :response_type
        end
      end
    end
  end
end
