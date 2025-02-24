# frozen_string_literal: true

require 'mindee'
require 'mindee/input/sources'
require 'mindee/errors'
require 'pdf-reader'

require_relative '../../data'

describe Mindee::Input::Source do
  context 'An image input file' do
    it 'should load a JPEG from a path' do
      input = Mindee::Input::Source::PathInputSource.new(File.join(DATA_DIR, 'file_types/receipt.jpg'))
      expect(input.file_mimetype).to eq('image/jpeg')

      input = Mindee::Input::Source::PathInputSource.new(File.join(DATA_DIR, 'file_types/receipt.jpga'))
      expect(input.file_mimetype).to eq('image/jpeg')
    end

    it 'should load a TIFF from a path' do
      input = Mindee::Input::Source::PathInputSource.new(File.join(DATA_DIR, 'file_types/receipt.tif'))
      expect(input.file_mimetype).to eq('image/tiff')

      input = Mindee::Input::Source::PathInputSource.new(File.join(DATA_DIR, 'file_types/receipt.tiff'))
      expect(input.file_mimetype).to eq('image/tiff')
    end

    it 'should load a HEIC from a path' do
      input = Mindee::Input::Source::PathInputSource.new(File.join(DATA_DIR, 'file_types/receipt.heic'))
      expect(input.file_mimetype).to eq('image/heic')
    end
  end

  context 'A PDF input file' do
    it 'should load a multi-page PDF from a path' do
      input = Mindee::Input::Source::PathInputSource.new(File.join(DATA_DIR, 'products/invoices/invoice.pdf'))
      expect(input.file_mimetype).to eq('application/pdf')
      expect(input.pdf?).to eq(true)

      input = Mindee::Input::Source::PathInputSource.new(File.join(DATA_DIR, 'products/invoices/invoice.pdf'))
      expect(input.file_mimetype).to eq('application/pdf')
      expect(input.pdf?).to eq(true)

      input = Mindee::Input::Source::PathInputSource.new(File.join(DATA_DIR, 'products/invoices/invoice_10p.pdf'))
      expect(input.file_mimetype).to eq('application/pdf')
      expect(input.pdf?).to eq(true)

      input = Mindee::Input::Source::PathInputSource.new(File.join(DATA_DIR, 'products/invoices/invoice_10p.pdf'))
      expect(input.file_mimetype).to eq('application/pdf')
      expect(input.pdf?).to eq(true)
    end
  end

  context 'A broken fixable PDF' do
    mindee_client = Mindee::Client.new(api_key: 'invalid-api-key')
    it 'Should not raise a mime error' do
      expect do
        mindee_client.source_from_path("#{DATA_DIR}/file_types/pdf/broken_fixable.pdf", repair_pdf: true)
      end.not_to raise_error
    end
  end

  context 'A broken unfixable PDF' do
    mindee_client = Mindee::Client.new(api_key: 'invalid-api-key')
    it 'Should raise an error' do
      expect do
        mindee_client.source_from_path("#{DATA_DIR}/file_types/pdf/broken_unfixable.pdf", repair_pdf: true)
      end.to raise_error Mindee::Errors::MindeePDFError
    end
  end

  context 'A broken fixable invoice PDF' do
    mindee_client = Mindee::Client.new(api_key: 'invalid-api-key')
    it 'Should send correct results' do
      source_doc_original = mindee_client.source_from_path("#{DATA_DIR}/products/invoices/invoice.pdf")
      expect do
        source_doc_fixed = mindee_client.source_from_path("#{DATA_DIR}/file_types/pdf/broken_invoice.pdf",
                                                          repair_pdf: true)
        expect(source_doc_fixed.read_contents[1].to_s).to eq(source_doc_original.read_contents[1].to_s)
      end.not_to raise_error
    end
  end
end
