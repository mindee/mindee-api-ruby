# frozen_string_literal: true

require_relative 'product'

module Mindee
  module Parsing
    # Common fields used for most documents.
    module Common
      # Abstract wrapper class for prediction Pages
      # Holds prediction for a page as well as it's orientation and  id.
      class Page
        # Id of the page (as given by the API).
        # @return [Integer]
        attr_reader :page_id
        # Orientation of the page.
        # @return [Mindee::Parsing::Common::Orientation]
        attr_reader :orientation
        # Page prediction
        # @return [Mindee::Parsing::Common::Prediction]
        attr_reader :prediction

        # @param raw_prediction [Hash]
        def initialize(raw_prediction)
          @page_id = raw_prediction['id']
          @orientation = Orientation.new(raw_prediction['orientation'], @page_id)
        end

        # @return [String]
        def to_s
          out_str = String.new
          title = "Page #{@page_id}"
          out_str << "#{title}\n"
          out_str << ('-' * title.size)
          out_str << @prediction.to_s
          out_str
        end
      end
    end
  end
end
