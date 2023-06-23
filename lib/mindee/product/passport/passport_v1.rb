# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'passport_v1_document'
require_relative 'passport_v1_page'

module Mindee
  module Product
    module Passport
      # Passport V1 prediction inference.
      class PassportV1 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'passport'
        @endpoint_version = '1'

        def initialize(http_response)
          super
          @prediction = PassportV1Document.new(http_response['prediction'], nil)
          @pages = []
          http_response['pages'].each do |page|
            @pages.push(PassportV1Page.new(page))
          end
        end

        class << self
          attr_reader :endpoint_name, :endpoint_version
        end
      end
    end
  end
end
