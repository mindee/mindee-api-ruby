# frozen_string_literal: true

require 'mindee/inputs'

DATA_DIR = File.join(__dir__, 'data').freeze

describe Mindee::InputDocument do
  context 'An image input file' do
    it 'should load a JPEG from a path' do
      input = Mindee::PathDocument.new(File.join(DATA_DIR, 'receipt/receipt.jpg'), false)
      expect(input.file_mimetype).to eq('image/jpeg')

      input = Mindee::PathDocument.new(File.join(DATA_DIR, 'passport/passport.jpeg'), false)
      expect(input.file_mimetype).to eq('image/jpeg')

      input = Mindee::PathDocument.new(File.join(DATA_DIR, 'receipt/receipt.jpga'), false)
      expect(input.file_mimetype).to eq('image/jpeg')
    end

    it 'should load a TIFF from a path' do
      input = Mindee::PathDocument.new(File.join(DATA_DIR, 'receipt/receipt.tif'), false)
      expect(input.file_mimetype).to eq('image/tiff')

      input = Mindee::PathDocument.new(File.join(DATA_DIR, 'receipt/receipt.tiff'), false)
      expect(input.file_mimetype).to eq('image/tiff')
    end

    it 'should load a HEIC from a path' do
      input = Mindee::PathDocument.new(File.join(DATA_DIR, 'receipt/receipt.heic'), false)
      expect(input.file_mimetype).to eq('image/heic')
    end
  end

  context 'A PDF input file' do
    it 'should load a PDF from a path' do
      input = Mindee::PathDocument.new(File.join(DATA_DIR, 'invoice/invoice.pdf'), false)
      expect(input.file_mimetype).to eq('application/pdf')
      expect(input.pdf?).to eq(true)
    end
  end
end
