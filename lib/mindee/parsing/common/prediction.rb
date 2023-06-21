# frozen_string_literal: true

module Mindee
  module Parsing
    module Common
      # Abstract class for all predictions
      class Prediction
        def to_s
          ''
        end
      end
    end
  end

  class Prediction < Mindee::Parsing::Common::Prediction
  end
end
