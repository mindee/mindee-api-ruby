# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'bank_check_v1_document'

module Mindee
  module Product
    module US
      module BankCheck
        # Bank Check V1 page prediction.
        class BankCheckV1Page < BankCheckV1Document
          include Mindee::Parsing::Common
          def initialize(http_response)
            @page_id = http_response['id']
            @orientation = Orientation.new(http_response['orientation'], @page_id)
            super(http_response['prediction'], @page_id)
          end

          # @return [String]
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
end
