# frozen_string_literal: true

module Mindee
  module Parsing
    module V2
      # Raw text extracted from a single page.
      class RawTextPage
        # @return [String] Text content of the page as a single string. '\n' is used to separate lines.
        attr_reader :content

        # @param server_response [Hash] Raw JSON parsed into a Hash.
        def initialize(server_response)
          @content = server_response['content']
        end

        def to_s
          @content
        end
      end
    end
  end
end
