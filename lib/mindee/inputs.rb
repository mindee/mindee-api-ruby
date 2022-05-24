# frozen_string_literal: true

require 'stringio'
require 'origami'
require 'marcel'

# Monkey-patching for Origami
module PDFTools
  def to_io_stream(params = {})
    options = {
      delinearize: true,
      recompile: true,
      decrypt: false,
    }
    options.update(params)

    if frozen? # incompatible flags with frozen doc (signed)
      options[:recompile] = nil
      options[:rebuild_xrefs] = nil
      options[:noindent] = nil
      options[:obfuscate] = false
    end
    load_all_objects unless @loaded

    intents_as_pdfa1 if options[:intent] =~ %r{pdf[/-]?A1?/i}
    delinearize! if options[:delinearize] && linearized?
    compile(options) if options[:recompile]

    io_stream = StringIO.new(output(options))
    io_stream.set_encoding Encoding::BINARY
    io_stream
  end
end

Origami::PDF.class_eval { include PDFTools }

module Mindee
  ALLOWED_MIME_TYPES = [
    'image/png',
    'image/jpg',
    'image/jpeg',
    'image/webp',
    'application/pdf',
  ].freeze

  # Base class for loading documents.
  class InputDocument
    # @return [String]
    attr_reader :filename
    # @return [String]
    attr_reader :filepath
    # @return [String]
    attr_reader :file_mimetype

    # @param cut_pdf [Boolean]
    # @param n_pdf_pages [Integer]
    def initialize(cut_pdf, n_pdf_pages)
      @file_mimetype = Marcel::MimeType.for @io_stream, name: @filename

      unless ALLOWED_MIME_TYPES.include? @file_mimetype
        raise "File type not allowed, must be one of #{ALLOWED_MIME_TYPES.join(', ')}"
      end

      merge_pdf_pages(n_pdf_pages) if cut_pdf && pdf?
    end

    def pdf?
      @file_mimetype == 'application/pdf'
    end

    # @param close [Boolean]
    def read_document(close: true)
      @io_stream.seek(0)
      data = @io_stream.read
      @io_stream.close if close
      [data].pack('m')
    end

    private

    # @param n_pdf_pages [Integer]
    def merge_pdf_pages(n_pdf_pages)
      pdf_parser = Origami::PDF::LinearParser.new({})
      cur_pdf = pdf_parser.parse(@io_stream)

      return if cur_pdf.pages.size > 3

      new_pdf = Origami::PDF.new

      cur_pdf.pages[0, n_pdf_pages].each_with_index do |page, idx|
        new_pdf.insert_page(idx, page)
      end
      @io_stream = new_pdf.to_io_stream
    end
  end

  # Load a document from a path.
  class PathDocument < InputDocument
    def initialize(filepath, cut_pdf, n_pdf_pages: 3)
      puts "opening #{filepath}"
      @io_stream = File.open(filepath, 'rb')
      @filepath = filepath
      super(cut_pdf, n_pdf_pages)
    end
  end

  # Load a document from a base64 string.
  class Base64Document < InputDocument
    def initialize(base64_string, filename, cut_pdf, n_pdf_pages: 3)
      @io_stream = StringIO.new(base64_string.unpack1('m*'))
      @io_stream.set_encoding Encoding::BINARY
      @filename = filename
      super(cut_pdf, n_pdf_pages)
    end
  end

  # Load a document from raw bytes.
  class BytesDocument < InputDocument
    def initialize(raw_bytes, filename, cut_pdf, n_pdf_pages: 3)
      @io_stream = StringIO.new(raw_bytes)
      @io_stream.set_encoding Encoding::BINARY
      @filename = filename
      super(cut_pdf, n_pdf_pages)
    end
  end

  # Load a document from a file handle.
  class FileDocument < InputDocument
    def initialize(file_handle, filename, cut_pdf, n_pdf_pages: 3)
      @io_stream = file_handle
      @filename = filename
      super(cut_pdf, n_pdf_pages)
    end
  end
end
