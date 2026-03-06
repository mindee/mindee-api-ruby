# frozen_string_literal: true

require_relative 'common_response'

module Mindee
  module V2
    module Parsing
      # Base class for V2 inference responses.
      class BaseResponse < Mindee::V2::Parsing::CommonResponse
        # @return [BaseInference] The inference result for a split utility request
        attr_reader :inference
      end
    end
  end
end
