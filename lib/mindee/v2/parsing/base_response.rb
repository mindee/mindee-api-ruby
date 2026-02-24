# frozen_string_literal: true

module Mindee
  module V2
    module Parsing
      # Base class for V2 inference responses.
      class BaseResponse < Mindee::Parsing::V2::CommonResponse
        # @return [BaseInference] The inference result for a split utility request
        attr_reader :inference

        # @return [String] The slug of the endpoint used for this response
        @_slug = 'extraction/results'
        # @return [Class<BaseParameters>] The class of the parameters used for this response
        @_params_type
      end
    end
  end
end
