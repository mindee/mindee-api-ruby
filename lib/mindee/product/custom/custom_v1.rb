# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'custom_v1_page'
require_relative 'custom_v1_document'

module Mindee
  module Product
    # Custom document object.
    class CustomV1 < Inference
      @endpoint_name = ''
      @endpoint_version = ''

      def initialize(http_response)
        super
        @prediction = CustomV1Document.new(http_response['prediction'], nil)
        @pages = []
        http_response['pages'].each do |page|
          @pages.push(CustomV1Page.new(page))
        end
      end

      class << self
        attr_reader :endpoint_name, :endpoint_version
      end
    end
  end
end
