# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'carte_vitale_v1_document'

module Mindee
  module Product
    module FR
      # License Plate v1 prediction results.
      class CarteVitaleV1Page < CarteVitaleV1Document
        # List of all license plates found in the image.
        # @return [Array<Mindee::TextField>]
        attr_reader :license_plates

        def initialize(http_response)
          @page_id = http_response['id']
          @orientation = Mindee::Parsing::Common::Orientation.new(http_response['orientation'], @page_id)
          super(http_response['prediction'], @page_id)
        end

        def to_s
          out_str = String.new
          title = "Page #{@page_id}"
          out_str << "#{title}\n"
          out_str << ('-' * title.size)
          out_str << "\n#{super}"
          out_str
        end
      end
    end
  end
end
