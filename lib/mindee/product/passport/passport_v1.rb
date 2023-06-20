# frozen_string_literal: true

require_relative 'passport_v1_document'

module Mindee
  module Product
    # Passport document.
    class PassportV1 < PassportV1Document
      @endpoint_name = 'passport'
      @endpoint_version = '1'

      class << self
        attr_reader :endpoint_name, :endpoint_version
      end
    end
  end
end
