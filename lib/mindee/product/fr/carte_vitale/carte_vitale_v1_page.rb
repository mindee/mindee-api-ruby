# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'carte_vitale_v1_document'

include Mindee::Parsing::Standard
include Mindee::Parsing::Common

module Mindee
  module Product
    module FR
      # Carte Vitale Page page prediction
      class CarteVitaleV1Page < CarteVitaleV1Document

        def initialize(http_response)
          @page_id = http_response['id']
          @orientation = Orientation.new(http_response['orientation'], @page_id)
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
