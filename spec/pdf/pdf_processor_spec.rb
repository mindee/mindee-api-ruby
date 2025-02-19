# frozen_string_literal: true

require 'mindee'

require_relative '../data'

describe Mindee::PDF do
  def open_pdf(io_stream)
    pdf_parser = Origami::PDF::LinearParser.new({})
    io_stream.seek(0)
    pdf_parser.parse(io_stream)
  end

  context 'A single page PDF' do
    filepath = File.join(DATA_DIR, 'file_types/pdf/blank.pdf').freeze

    it 'Should grab the first page' do
      io_stream = File.open(filepath, 'rb')
      io_stream.seek(0)
      options = Mindee::PageOptions.new(params: {
                                          page_indexes: [0],
                                          operation: :KEEP_ONLY,
                                          on_min_pages: 0,
                                        })
      new_stream = Mindee::PDF::PDFProcessor.parse(io_stream, options)
      new_pdf = open_pdf(new_stream)
      expect(new_pdf.pages.size).to eq(1)
    end

    it 'Should grab the last page' do
      io_stream = File.open(filepath, 'rb')
      io_stream.seek(0)
      options = Mindee::PageOptions.new(params: {
                                          page_indexes: [-1],
                                          operation: :KEEP_ONLY,
                                          on_min_pages: 0,
                                        })
      new_stream = Mindee::PDF::PDFProcessor.parse(io_stream, options)
      new_pdf = open_pdf(new_stream)
      expect(new_pdf.pages.size).to eq(1)
    end
  end

  context 'A multi-page PDF' do
    filepath = File.join(DATA_DIR, 'file_types/pdf/multipage.pdf').freeze

    it 'Should grab the first page' do
      io_stream = File.open(filepath, 'rb')
      io_stream.seek(0)
      options = Mindee::PageOptions.new(params: {
                                          page_indexes: [0],
                                          operation: :KEEP_ONLY,
                                          on_min_pages: 0,
                                        })
      new_stream = Mindee::PDF::PDFProcessor.parse(io_stream, options)
      new_pdf = open_pdf(new_stream)
      expect(new_pdf.pages.size).to eq(1)
    end

    it 'Should grab the last page' do
      io_stream = File.open(filepath, 'rb')
      io_stream.seek(0)
      options = Mindee::PageOptions.new(params: {
                                          page_indexes: [-1],
                                          operation: :KEEP_ONLY,
                                          on_min_pages: 0,
                                        })
      new_stream = Mindee::PDF::PDFProcessor.parse(io_stream, options)
      new_pdf = open_pdf(new_stream)
      expect(new_pdf.pages.size).to eq(1)
    end

    it 'Should grab the first 2, and the last page' do
      io_stream = File.open(filepath, 'rb')
      io_stream.seek(0)
      options = Mindee::PageOptions.new(params: {
                                          page_indexes: [0, 1, -1],
                                          operation: :KEEP_ONLY,
                                          on_min_pages: 0,
                                        })
      new_stream = Mindee::PDF::PDFProcessor.parse(io_stream, options)
      new_pdf = open_pdf(new_stream)
      expect(new_pdf.pages.size).to eq(3)
    end

    it 'Should grab the first 5 pages' do
      io_stream = File.open(filepath, 'rb')
      io_stream.seek(0)
      options = Mindee::PageOptions.new(params: {
                                          page_indexes: [0, 1, 2, 3, 4],
                                          operation: :KEEP_ONLY,
                                          on_min_pages: 0,
                                        })
      new_stream = Mindee::PDF::PDFProcessor.parse(io_stream, options)
      new_pdf = open_pdf(new_stream)
      expect(new_pdf.pages.size).to eq(5)
    end

    it 'Should remove the first 3 pages' do
      io_stream = File.open(filepath, 'rb')
      io_stream.seek(0)
      options = Mindee::PageOptions.new(params: {
                                          page_indexes: [0, 1, 2],
                                          operation: :REMOVE,
                                          on_min_pages: 0,
                                        })
      new_stream = Mindee::PDF::PDFProcessor.parse(io_stream, options)
      new_pdf = open_pdf(new_stream)
      expect(new_pdf.pages.size).to eq(9)
    end

    it 'Should fail on invalid operation' do
      io_stream = File.open(filepath, 'rb')
      io_stream.seek(0)
      options = Mindee::PageOptions.new(params: {
                                          page_indexes: [1],
                                          operation: :broken,
                                          on_min_pages: 0,
                                        })
      expect do
        Mindee::PDF::PDFProcessor.parse(io_stream, options)
      end.to raise_error ArgumentError
    end
  end
end
