# frozen_string_literal: true

require 'mindee'
require 'mindee/input/sources'
require 'mindee/errors'
require 'pdf-reader'

require_relative '../../data'

describe Mindee::Input::Source do
  context 'An image input file' do
    it 'should load a JPEG from a path' do
      input_source = Mindee::Input::Source::PathInputSource.new(
        File.join(FILE_TYPES_DIR, 'receipt.jpg')
      )
      expect(input_source.file_mimetype).to eq('image/jpeg')
      expect(input_source.filename).to eq('receipt.jpg')
      expect(input_source.page_count).to eq(1)
      expect(input_source.pdf?).to eq(false)

      input_source = Mindee::Input::Source::PathInputSource.new(
        File.join(FILE_TYPES_DIR, 'receipt.jpga')
      )
      expect(input_source.file_mimetype).to eq('image/jpeg')
      expect(input_source.filename).to eq('receipt.jpga')
      expect(input_source.page_count).to eq(1)
      expect(input_source.pdf?).to eq(false)
    end

    it 'should load a TIFF from a path' do
      input_source = Mindee::Input::Source::PathInputSource.new(
        File.join(FILE_TYPES_DIR, 'receipt.tif')
      )
      expect(input_source.file_mimetype).to eq('image/tiff')
      expect(input_source.filename).to eq('receipt.tif')
      expect(input_source.page_count).to eq(1)
      expect(input_source.pdf?).to eq(false)

      input_source = Mindee::Input::Source::PathInputSource.new(
        File.join(FILE_TYPES_DIR, 'receipt.tiff')
      )
      expect(input_source.file_mimetype).to eq('image/tiff')
      expect(input_source.filename).to eq('receipt.tiff')
      expect(input_source.page_count).to eq(1)
      expect(input_source.pdf?).to eq(false)
    end

    it 'should load a HEIC from a path' do
      input_source = Mindee::Input::Source::PathInputSource.new(
        File.join(FILE_TYPES_DIR, 'receipt.heic')
      )
      expect(input_source.file_mimetype).to eq('image/heic')
      expect(input_source.filename).to eq('receipt.heic')
      expect(input_source.page_count).to eq(1)
      expect(input_source.pdf?).to eq(false)
    end
  end

  context 'A PDF input file' do
    it 'should load a multi-page PDF from a path' do
      input_source = Mindee::Input::Source::PathInputSource.new(
        File.join(V1_DATA_DIR, 'products/invoices/invoice.pdf')
      )
      expect(input_source.file_mimetype).to eq('application/pdf')
      expect(input_source.filename).to eq('invoice.pdf')
      expect(input_source.page_count).to eq(2)
      expect(input_source.pdf?).to eq(true)

      input_source = Mindee::Input::Source::PathInputSource.new(
        File.join(V1_DATA_DIR, 'products/invoices/invoice.pdf')
      )
      expect(input_source.file_mimetype).to eq('application/pdf')
      expect(input_source.filename).to eq('invoice.pdf')
      expect(input_source.page_count).to eq(2)
      expect(input_source.pdf?).to eq(true)

      input_source = Mindee::Input::Source::PathInputSource.new(
        File.join(V1_DATA_DIR, 'products/invoices/invoice_10p.pdf')
      )
      expect(input_source.file_mimetype).to eq('application/pdf')
      expect(input_source.filename).to eq('invoice_10p.pdf')
      expect(input_source.page_count).to eq(10)
      expect(input_source.pdf?).to eq(true)
    end
  end

  context 'A broken fixable PDF' do
    mindee_client = Mindee::Client.new(api_key: 'invalid-api-key')
    it 'Should not raise a mime error' do
      expect do
        mindee_client.source_from_path(
          "#{FILE_TYPES_DIR}/pdf/broken_fixable.pdf", repair_pdf: true
        )
      end.not_to raise_error
    end
  end

  context 'A broken unfixable PDF' do
    mindee_client = Mindee::Client.new(api_key: 'invalid-api-key')
    it 'Should raise an error' do
      expect do
        mindee_client.source_from_path(
          "#{FILE_TYPES_DIR}/pdf/broken_unfixable.pdf", repair_pdf: true
        )
      end.to raise_error Mindee::Errors::MindeePDFError
    end
  end

  context 'A broken fixable invoice PDF' do
    mindee_client = Mindee::Client.new(api_key: 'invalid-api-key')
    it 'Should send correct results' do
      source_doc_original = mindee_client.source_from_path("#{V1_DATA_DIR}/products/invoices/invoice.pdf")
      expect do
        source_doc_fixed = mindee_client.source_from_path("#{FILE_TYPES_DIR}/pdf/broken_invoice.pdf",
                                                          repair_pdf: true)
        expect(source_doc_fixed.read_contents[0].to_s).to eq(source_doc_original.read_contents[0].to_s)
      end.not_to raise_error
    end
  end
end
