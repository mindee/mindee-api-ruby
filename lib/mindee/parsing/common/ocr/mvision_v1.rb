# frozen_string_literal: true

module Mindee
  module Parsing
    module Common
      module Ocr
        # Mindee Vision V1.
        class MVisionV1
          # List of pages.
          # @return [Array<OcrPage>]
          attr_reader :pages

          # @param prediction [Hash]
          def initialize(prediction)
            @pages = []
            prediction['pages'].each do |page_prediction|
              @pages.push(OcrPage.new(page_prediction))
            end
          end

          def to_s
            out_str = String.new
            @pages.map do |page|
              out_str << "\n"
              out_str << page.to_s
            end
            out_str.strip
          end
        end
      end
    end
  end
end
