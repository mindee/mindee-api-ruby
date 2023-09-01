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
end
