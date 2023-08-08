# frozen_string_literal: true

require 'mindee/input/sources'
require 'base64'
require_relative '../data'

describe Mindee::Input::Source::LocalInputSource do
  context 'An jpg input file' do
    it 'should be converted as a valid byte64 string' do
      file = File.join(DATA_DIR, 'receipt/receipt.jpg')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_document
      expect(read_f[1]).to eq(Base64.encode64(File.read(file)))
    end
  end

  context 'A jpga input file' do
    it 'should be converted as a valid byte64 string' do
      file = File.join(DATA_DIR, 'receipt/receipt.jpga')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_document
      expect(read_f[1]).to eq(Base64.encode64(File.read(file)))
    end
  end

  context 'A heic input file' do
    it 'should be converted as a valid byte64 string' do
      file = File.join(DATA_DIR, 'receipt/receipt.heic')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_document
      expect(read_f[1]).to eq(Base64.encode64(File.read(file)))
    end
  end

  context 'A tif input file' do
    it 'should be converted as a valid byte64 string' do
      file = File.join(DATA_DIR, 'receipt/receipt.tif')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_document
      expect(read_f[1]).to eq(Base64.encode64(File.read(file)))
    end
  end

  context 'A tiff input file' do
    it 'should be converted as a valid byte64 string' do
      file = File.join(DATA_DIR, 'receipt/receipt.tiff')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_document
      expect(read_f[1]).to eq(Base64.encode64(File.read(file)))
    end
  end

  context 'A txt input file' do
    it 'should be converted as a valid byte64 string' do
      file = File.join(DATA_DIR, 'receipt/receipt.txt')
      input = Mindee::Input::Source::Base64InputSource.new(File.read(file), 'receipt.txt')
      read_f = input.read_document
      # NOTE: pack() & Base64.encodebase64 inputs have different rules for line breaks
      # which also differ from the ones in the base file. For all intents and purposes,
      # we can ignore them.
      expect(read_f[1].gsub("\n", '')).to eq(File.read(file).gsub("\n", ''))
    end
  end

  context 'A standard pdf input file' do
    it 'should not be converted' do
      file = File.join(DATA_DIR, 'pdf/not_blank_image_only.pdf')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_document
      file_contents = File.read(file)
      expect(read_f[1]).to_not eq(Base64.encode64(file_contents))
      expect(Base64.decode64(read_f[1])).to eq(Base64.decode64(file_contents))
    end
  end

  context 'A valid written pdf input file' do
    it 'should not be converted' do
      file = File.join(DATA_DIR, 'pdf/valid_exported.pdf')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_document
      file_contents = File.read(file)
      expect(read_f[1]).to_not eq(Base64.encode64(file_contents))
      expect(Base64.decode64(read_f[1])).to eq(Base64.decode64(file_contents))
    end
  end
end