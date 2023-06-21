# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'proof_of_address_v1_document'
require_relative 'proof_of_address_v1_page'

module Mindee
  module Product
    # Proof of Address v1 prediction results.
    class ProofOfAddressV1 < Inference
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
        attr_reader :endpoint_name, :endpoint_version
      end
    end
  end
end
