# frozen_string_literal: true

require 'stringio'

module Mindee
  module Input
    # Document source handling.
    module Source
      # Load a document from a path.
      class PathInputSource < LocalInputSource
        # @param filepath [String]
        # @param fix_pdf [Boolean]
        def initialize(filepath, fix_pdf: false)
          io_stream = File.open(filepath, 'rb')
          super(io_stream, File.basename(filepath), fix_pdf: fix_pdf)
        end
      end
    end
  end
end
