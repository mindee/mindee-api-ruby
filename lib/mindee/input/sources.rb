# frozen_string_literal: true

require 'stringio'
require 'marcel'

require_relative 'pdf_processing'

module Mindee
  module Input
    ALLOWED_MIME_TYPES = [
      'application/pdf',
      'image/heic',
      'image/png',
      'image/jpeg',
      'image/tiff',
      'image/webp',
    ].freeze

    # Base class for loading documents.
    class LocalInputSource
      # @return [String]
      attr_reader :filename
      # @return [String]
      attr_reader :file_mimetype
      # @return [StreamIO]
      attr_reader :io_stream

      # @param io_stream [StreamIO]
      def initialize(io_stream, filename)
        @io_stream = io_stream
        @filename = filename
        @file_mimetype = Marcel::MimeType.for @io_stream, name: @filename

        return if ALLOWED_MIME_TYPES.include? @file_mimetype

        raise "File type not allowed, must be one of #{ALLOWED_MIME_TYPES.join(', ')}"
      end

      def pdf?
        @file_mimetype == 'application/pdf'
      end

      def process_pdf(options)
        @io_stream.seek(0)
        @io_stream = PdfProcessor.parse(@io_stream, options)
      end

      # @param close [Boolean]
      def read_document(close: true)
        @io_stream.seek(0)
        data = @io_stream.read
        @io_stream.close if close
        [data].pack('m')
      end
    end

    # Load a document from a path.
    class PathInputSource < LocalInputSource
      # @param filepath [String]
      def initialize(filepath)
        io_stream = File.open(filepath, 'rb')
        super(io_stream, File.basename(filepath))
      end
    end

    # Load a document from a base64 string.
    class Base64InputSource < LocalInputSource
      # @param base64_string [String]
      # @param filename [String]
      def initialize(base64_string, filename)
        io_stream = StringIO.new(base64_string.unpack1('m*'))
        io_stream.set_encoding Encoding::BINARY
        super(io_stream, filename)
      end
    end

    # Load a document from raw bytes.
    class BytesInputSource < LocalInputSource
      # @param raw_bytes [String]
      # @param filename [String]
      def initialize(raw_bytes, filename)
        io_stream = StringIO.new(raw_bytes)
        io_stream.set_encoding Encoding::BINARY
        super(io_stream, filename)
      end
    end

    # Load a document from a file handle.
    class FileInputSource < LocalInputSource
      # @param filename [String]
      def initialize(file_handle, filename)
        io_stream = file_handle
        super(io_stream, filename)
      end
    end

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
