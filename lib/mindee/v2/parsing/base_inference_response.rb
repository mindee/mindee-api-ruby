# frozen_string_literal: true

require_relative 'base_response'

module Mindee
  module V2
    module Parsing
      # Base class for V2 inference responses.
      class BaseInferenceResponse < Mindee::V2::Parsing::BaseResponse
        # @return [BaseInference] The inference result for a split utility request
        attr_reader :inference
      end
    end
  end
end
