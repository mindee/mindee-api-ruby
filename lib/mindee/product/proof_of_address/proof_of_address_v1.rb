# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'proof_of_address_v1_document'
require_relative 'proof_of_address_v1_page'

module Mindee
  module Product
    module ProofOfAddress
      # Proof of Address v1 prediction results.
      class ProofOfAddressV1 < Mindee::Parsing::Common::Inference
        @endpoint_name = 'proof_of_address'
        @endpoint_version = '1'

        def initialize(http_response)
          super
          @prediction = ProofOfAddressV1Document.new(http_response['prediction'], nil)
          @pages = []
          http_response['pages'].each do |page|
            @pages.push(ProofOfAddressV1Page.new(page))
          end
        end

        class << self
          # Name of the endpoint for this product.
          # @return [String]
          attr_reader :endpoint_name
          # Version for this product.
          # @return [String]
          attr_reader :endpoint_version
        end
      end
    end
  end
end
