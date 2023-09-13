# frozen_string_literal: true

require 'mindee/input/sources'

require_relative '../data'

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

  context 'A remote url file' do
    it 'should not send an invalid URL' do
      expect do
        Mindee::Input::Source::UrlInputSource.new('http://invalid-url')
      end.to raise_error 'URL must be HTTPS'
    end
    it 'should send a valid URL' do
      input = Mindee::Input::Source::UrlInputSource.new('https://platform.mindee.com')
      expect(input.url).to eq('https://platform.mindee.com')
    end
  end

  context 'A broken fixable PDF' do
    mindee_client = Mindee::Client.new(api_key: 'invalid-api-key')
    it 'Should not raise a mime error' do
      expect do
        mindee_client.source_from_path("#{DATA_DIR}/file_types/pdf/broken_fixable.pdf", fix_pdf: true)
      end.not_to raise_error
    end
  end

  context 'A broken unfixable PDF' do
    mindee_client = Mindee::Client.new(api_key: 'invalid-api-key')
    it 'Should raise an error' do
      expect do
        mindee_client.source_from_path("#{DATA_DIR}/file_types/pdf/broken_unfixable.pdf", fix_pdf: true)
      end.to raise_error Mindee::Input::Source::UnfixablePDFError
    end
  end

  context 'A broken fixable invoice PDF' do
    mindee_client = Mindee::Client.new(api_key: 'invalid-api-key')
    it 'Should send correct results' do
      source_doc_original = mindee_client.source_from_path("#{DATA_DIR}/products/invoices/invoice.pdf")
      expect do
        source_doc_fixed = mindee_client.source_from_path("#{DATA_DIR}/file_types/pdf/broken_invoice.pdf",
                                                          fix_pdf: true)
        expect(source_doc_fixed.read_document[1].to_s).to eq(source_doc_original.read_document[1].to_s)
      end.not_to raise_error
    end
  end
end
