# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'resume_v1_document'

module Mindee
  module Product
    module Resume
      # Resume API version 1.2 page data.
      class ResumeV1Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = if prediction['prediction'].empty?
                          nil
                        else
                          ResumeV1PagePrediction.new(
                            prediction['prediction'],
                            prediction['id']
                          )
                        end
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
