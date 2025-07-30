# frozen_string_literal: true

module Mindee
  module Parsing
    module V2
      # Raw text extracted from a given page.
      class RawText
        # @return [Integer] Page number where the text was found.
        attr_reader :page
        # @return [String] Text content.
        attr_reader :content

        # @param server_response [Hash] Raw JSON parsed into a Hash.
        def initialize(server_response)
          @page = server_response['page']
          @content = server_response['content']
        end
      end
    end
  end
end
