# frozen_string_literal: true

require_relative 'custom_v1_page'

module Mindee
  module Product
    # Custom document object.
    class CustomV1 < CustomV1Document
      @endpoint_name = ''
      @endpoint_version = '1'

      class << self
        attr_reader :endpoint_name, :endpoint_version
      end
    end
  end
end
