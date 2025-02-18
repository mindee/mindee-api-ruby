# frozen_string_literal: true

module Mindee
  module Parsing
    module Common
      # Abstract class for all predictions
      class Prediction
        # @return [String]
        def to_s
          ''
        end

        def initialize(_ = nil, _ = nil); end
      end
    end
  end
end
