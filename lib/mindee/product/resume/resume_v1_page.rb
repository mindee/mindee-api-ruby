# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'resume_v1_document'

module Mindee
  module Product
    module Resume
      # Resume V1 page.
      class ResumeV1Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super(prediction)
          @prediction = ResumeV1PagePrediction.new(
            prediction['prediction'],
            prediction['id']
          )
        end
      end

      # Resume V1 page prediction.
      class ResumeV1PagePrediction < ResumeV1Document
        # @return [String]
        def to_s
          out_str = String.new
          out_str << "\n#{super}"
          out_str
        end
      end
    end
  end
end
