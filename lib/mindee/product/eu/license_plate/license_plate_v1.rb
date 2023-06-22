# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'license_plate_v1_document'
require_relative 'license_plate_v1_page'

include Mindee::Parsing::Common

module Mindee
  module Product
    module EU
      # License Plate v1 prediction inference.
      class LicensePlateV1 < Inference
        @endpoint_name = 'license_plates'
        @endpoint_version = '1'

        def initialize(http_response)
          super
          @prediction = LicensePlateV1Document.new(http_response['prediction'], nil)
          @pages = []
          http_response['pages'].each do |page|
            @pages.push(LicensePlateV1Page.new(page))
          end
        end

        class << self
          attr_reader :endpoint_name, :endpoint_version
        end
      end
    end
  end
end
