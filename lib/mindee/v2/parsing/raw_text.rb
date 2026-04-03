# frozen_string_literal: true

module Mindee
  module V2
    module Parsing
      # Raw text extracted from all pages in the document.
      class RawText
        # @return [Array[Mindee::V2::Parsing::RawTextPage]] List of pages with their extracted text content.
        attr_reader :pages

        # @param server_response [Hash] Raw JSON parsed into a Hash.
        def initialize(server_response)
          @pages = []
          server_response.fetch('pages', []).each do |page|
            @pages.push RawTextPage.new(page)
          end
        end

        # String representation.
        # @return [String]
        def to_s
          "#{@pages.join("\n\n")}\n"
        end
      end
    end
  end
end
