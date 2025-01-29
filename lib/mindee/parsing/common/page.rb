# frozen_string_literal: true

require_relative 'product'
require_relative 'extras'

module Mindee
  module Parsing
    # Common fields used for most documents.
    module Common
      # Abstract wrapper class for prediction Pages
      # Holds prediction for a page as well as it's orientation and  id.
      class Page
        # ID of the page (as given by the API).
        # @return [Integer]
        attr_reader :page_id
        # Orientation of the page.
        # @return [Mindee::Parsing::Common::Orientation]
        attr_reader :orientation
        # Page prediction
        # @return [Mindee::Parsing::Common::Prediction]
        attr_reader :prediction
        # Additional page-level information.
        # @return [Mindee::Parsing::Common::Extras::Extras]
        attr_reader :extras

        # @param raw_prediction [Hash]
        def initialize(raw_prediction)
          @page_id = raw_prediction['id']
          @orientation = Orientation.new(raw_prediction['orientation'], @page_id)
          @extras = Extras::Extras.new(raw_prediction['extras']) unless raw_prediction['extras'].nil?
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
