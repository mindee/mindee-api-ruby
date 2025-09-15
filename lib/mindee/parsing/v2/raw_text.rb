# frozen_string_literal: true

module Mindee
  module Parsing
    module V2
      # Raw text extracted from all pages in the document.
      class RawText
        # @return [Array[Mindee::Parsing::V2::RawTextPage]] List of pages with their extracted text content.
        attr_reader :pages

        # @param server_response [Hash] Raw JSON parsed into a Hash.
        def initialize(server_response)
          @pages = []
          server_response.fetch('pages', []).each do |page|
            @pages.push RawTextPage.new(page)
          end
        end
      end
    end
  end
end
