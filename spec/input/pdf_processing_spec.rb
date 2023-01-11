# frozen_string_literal: true

require 'mindee/input/pdf_processing'

require_relative '../data'

describe Mindee::Input do
  def open_pdf(io_stream)
    pdf_parser = Origami::PDF::LinearParser.new({})
    io_stream.seek(0)
    pdf_parser.parse(io_stream)
  end

  context 'A single page PDF' do
    filepath = File.join(DATA_DIR, 'pdf/blank.pdf').freeze

    it 'Should grab the first page' do
      io_stream = File.open(filepath, 'rb')
      io_stream.seek(0)
      options = {
        page_indexes: [0],
        operation: :KEEP_ONLY,
        on_min_pages: 0,
      }
      new_stream = Mindee::Input::PdfProcessor.parse(io_stream, options)
      new_pdf = open_pdf(new_stream)
      expect(new_pdf.pages.size).to eq(1)
    end

    it 'Should grab the last page' do
      io_stream = File.open(filepath, 'rb')
      io_stream.seek(0)
      options = {
        page_indexes: [-1],
        operation: :KEEP_ONLY,
        on_min_pages: 0,
      }
      new_stream = Mindee::Input::PdfProcessor.parse(io_stream, options)
      new_pdf = open_pdf(new_stream)
      expect(new_pdf.pages.size).to eq(1)
    end
  end

  context 'A multi-page PDF' do
    filepath = File.join(DATA_DIR, 'pdf/multipage.pdf').freeze

    it 'Should grab the first page' do
      io_stream = File.open(filepath, 'rb')
      io_stream.seek(0)
      options = {
        page_indexes: [0],
        operation: :KEEP_ONLY,
        on_min_pages: 0,
      }
      new_stream = Mindee::Input::PdfProcessor.parse(io_stream, options)
      new_pdf = open_pdf(new_stream)
      expect(new_pdf.pages.size).to eq(1)
    end

    it 'Should grab the last page' do
      io_stream = File.open(filepath, 'rb')
      io_stream.seek(0)
      options = {
        page_indexes: [-1],
        operation: :KEEP_ONLY,
        on_min_pages: 0,
      }
      new_stream = Mindee::Input::PdfProcessor.parse(io_stream, options)
      new_pdf = open_pdf(new_stream)
      expect(new_pdf.pages.size).to eq(1)
    end

    it 'Should grab the first 2, and the last page' do
      io_stream = File.open(filepath, 'rb')
      io_stream.seek(0)
      options = {
        page_indexes: [0, 1, -1],
        operation: :KEEP_ONLY,
        on_min_pages: 0,
      }
      new_stream = Mindee::Input::PdfProcessor.parse(io_stream, options)
      new_pdf = open_pdf(new_stream)
      expect(new_pdf.pages.size).to eq(3)
    end

    it 'Should grab the first 5 pages' do
      io_stream = File.open(filepath, 'rb')
      io_stream.seek(0)
      options = {
        page_indexes: [0, 1, 2, 3, 4],
        operation: :KEEP_ONLY,
        on_min_pages: 0,
      }
      new_stream = Mindee::Input::PdfProcessor.parse(io_stream, options)
      new_pdf = open_pdf(new_stream)
      expect(new_pdf.pages.size).to eq(5)
    end

    it 'Should remove the first 3 pages' do
      io_stream = File.open(filepath, 'rb')
      io_stream.seek(0)
      options = {
        page_indexes: [0, 1, 2],
        operation: :REMOVE,
        on_min_pages: 0,
      }
      new_stream = Mindee::Input::PdfProcessor.parse(io_stream, options)
      new_pdf = open_pdf(new_stream)
      expect(new_pdf.pages.size).to eq(9)
    end
  end
end
