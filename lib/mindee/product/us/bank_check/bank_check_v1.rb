# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'bank_check_v1_document'
require_relative 'bank_check_v1_page'

import Mindee::Parsing::Common

module Mindee
  module Product
    module US
      # Bank Check Inference
      class BankCheckV1 < Inference
        @endpoint_name = 'bank_check'
        @endpoint_version = '1'

        def initialize(http_response)
          super
          @prediction = BankCheckV1Document.new(http_response['prediction'], nil)
          @pages = []
          http_response['pages'].each do |page|
            @pages.push(BankCheckV1Page.new(page))
          end
        end

        class << self
          attr_reader :endpoint_name, :endpoint_version
        end
      end
    end
  end
end
