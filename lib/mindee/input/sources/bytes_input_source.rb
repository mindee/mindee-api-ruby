# frozen_string_literal: true

require 'stringio'

module Mindee
  module Input
    module Source
      # Load a document from raw bytes.
      class BytesInputSource < LocalInputSource
        # @param raw_bytes [String]
        # @param filename [String]
        # @param fix_pdf [Boolean]
        def initialize(raw_bytes, filename, fix_pdf: false)
          io_stream = StringIO.new(raw_bytes)
          io_stream.set_encoding Encoding::BINARY
          super(io_stream, filename, fix_pdf: fix_pdf)
        end
      end
    end
  end
end
