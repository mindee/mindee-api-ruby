# frozen_string_literal: true

require 'stringio'
require 'marcel'

require_relative '../pdf'

module Mindee
  module Input
    module Source
      # Mime types accepted by the server.
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
        # @return [StringIO]
        attr_reader :io_stream

        # @param io_stream [StringIO]
        # @param filename [String]
        # @param fix_pdf [Boolean]
        def initialize(io_stream, filename, fix_pdf: false)
          @io_stream = io_stream
          @filename = filename
          @file_mimetype = Marcel::MimeType.for @io_stream, name: @filename
          return if ALLOWED_MIME_TYPES.include? @file_mimetype

          if filename.end_with?('.pdf') && fix_pdf
            rescue_broken_pdf(@io_stream)
            @file_mimetype = Marcel::MimeType.for @io_stream, name: @filename

            return if ALLOWED_MIME_TYPES.include? @file_mimetype
          end

          raise "File type not allowed, must be one of #{ALLOWED_MIME_TYPES.join(', ')}"
        end

        # Attempts to fix pdf files if mimetype is rejected.
        # "Broken PDFs" are often a result of third-party injecting invalid headers.
        # This attempts to remove them and send the file
        # @param stream [StringIO]
        def rescue_broken_pdf(stream)
          stream.gets('%PDF-')
          raise "Corrupted PDF isn't fixeable." if stream.pos > 500 || stream.eof?

          stream.pos = stream.pos - 5
          data = stream.read
          @io_stream.close

          @io_stream = StringIO.new
          @io_stream << data
        end

        # Shorthand for pdf mimetype validation.
        def pdf?
          @file_mimetype.to_s == 'application/pdf'
        end

        # Parses a PDF file according to provided options.
        # @param options [Hash, nil] Page cutting/merge options:
        #
        #  * `:page_indexes` Zero-based list of page indexes.
        #  * `:operation` Operation to apply on the document, given the `page_indexes specified:
        #      * `:KEEP_ONLY` - keep only the specified pages, and remove all others.
        #      * `:REMOVE` - remove the specified pages, and keep all others.
        #  * `:on_min_pages` Apply the operation only if document has at least this many pages.
        def process_pdf(options)
          @io_stream.seek(0)
          @io_stream = PdfProcessor.parse(@io_stream, options)
        end

        # Reads a document. Packs it into bytes if needed.
        # Note: only needs filename in case of some pdf files.
        # @param close [Boolean]
        # @return [Array<String, [String, aBinaryString ], [Hash, nil] >]
        def read_document(close: true)
          @io_stream.seek(0)
          # Avoids needlessly re-packing some files
          data = @io_stream.read
          @io_stream.close if close
          return ['document', data, { filename: @filename }] if pdf?

          ['document', [data].pack('m')]
        end
      end

      # Load a document from a path.
      class PathInputSource < LocalInputSource
        # @param filepath [String]
        # @param fix_pdf [Boolean]
        def initialize(filepath, fix_pdf: false)
          io_stream = File.open(filepath, 'rb')
          super(io_stream, File.basename(filepath), fix_pdf: fix_pdf)
        end
      end

      # Load a document from a base64 string.
      class Base64InputSource < LocalInputSource
        # @param base64_string [String]
        # @param filename [String]
        # @param fix_pdf [Boolean]
        def initialize(base64_string, filename, fix_pdf: false)
          io_stream = StringIO.new(base64_string.unpack1('m*'))
          io_stream.set_encoding Encoding::BINARY
          super(io_stream, filename, fix_pdf: fix_pdf)
        end
      end

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

      # Load a document from a file handle.
      class FileInputSource < LocalInputSource
        # @param file_handle [String]
        # @param filename [String]
        # @param fix_pdf [Boolean]
        def initialize(file_handle, filename, fix_pdf: false)
          io_stream = file_handle
          super(io_stream, filename, fix_pdf: fix_pdf)
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
end
