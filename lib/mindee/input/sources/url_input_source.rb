# frozen_string_literal: true

module Mindee
  module Input
    module Source
      # Load a remote document from a file url.
      class UrlInputSource
        # @return [String]
        attr_reader :url

        def initialize(url)
          raise 'URL must be HTTPS' unless url.start_with? 'https://'

          @url = url
        end
      end
    end
  end
end
