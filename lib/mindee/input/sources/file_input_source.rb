# frozen_string_literal: true

require 'stringio'

module Mindee
  module Input
    module Source
      # Load a document from a file handle.
      class FileInputSource < LocalInputSource
        # @param input_file [File]
        # @param filename [String]
        # @param fix_pdf [Boolean]
        def initialize(input_file, filename, fix_pdf: false)
          io_stream = input_file
          super(io_stream, filename, fix_pdf: fix_pdf)
        end
      end
    end
  end
end
