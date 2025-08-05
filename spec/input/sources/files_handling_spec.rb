# frozen_string_literal: true

require 'mindee/input/sources'
require 'base64'
require_relative '../../data'

describe Mindee::Input::Source::LocalInputSource do
  context 'An jpg input file' do
    it 'should be readable as raw bytes' do
      file = File.join(DATA_DIR, 'file_types/receipt.jpg')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_contents
      expect(read_f.length).to eq(2)
      expect(read_f[0]).to eq(File.read(file, mode: 'rb'))
    end
  end

  context 'A jpga input file' do
    it 'should be readable as raw bytes' do
      file = File.join(DATA_DIR, 'file_types/receipt.jpga')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_contents
      expect(read_f.length).to eq(2)
      expect(read_f[0]).to eq(File.read(file, mode: 'rb'))
    end
  end

  context 'A heic input file' do
    it 'should be readable as raw bytes' do
      file = File.join(DATA_DIR, 'file_types/receipt.heic')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_contents
      expect(read_f.length).to eq(2)
      expect(read_f[0]).to eq(File.read(file, mode: 'rb'))
    end
  end

  context 'A tif input file' do
    it 'should be readable as raw bytes' do
      file = File.join(DATA_DIR, 'file_types/receipt.tif')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_contents
      expect(read_f.length).to eq(2)
      expect(read_f[0]).to eq(File.read(file, mode: 'rb'))
    end
  end

  context 'A tiff input file' do
    it 'should be readable as raw bytes' do
      file = File.join(DATA_DIR, 'file_types/receipt.tiff')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_contents
      expect(read_f.length).to eq(2)
      expect(read_f[0]).to eq(File.read(file, mode: 'rb'))
    end
  end

  context 'A txt input file' do
    it 'should stay in base64' do
      file = File.join(DATA_DIR, 'file_types/receipt.txt')
      input = Mindee::Input::Source::Base64InputSource.new(File.read(file), 'receipt.txt')
      read_f = input.read_contents
      expect(read_f.length).to eq(2)
      expect(read_f[0].gsub("\n", '')).to eq(File.read(file).gsub("\n", ''))
    end
  end

  context 'A standard pdf input file' do
    it 'should not be converted' do
      file = File.join(DATA_DIR, 'file_types/pdf/not_blank_image_only.pdf')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_contents
      file_contents = File.read(file)
      expect(read_f[0]).to_not eq(Base64.encode64(file_contents))
      expect(read_f.length).to eq(2)
      expect(Base64.decode64(read_f[0])).to eq(Base64.decode64(file_contents))
    end
  end

  context 'A valid written pdf input file' do
    it 'should not be converted' do
      file = File.join(DATA_DIR, 'file_types/pdf/valid_exported.pdf')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_contents
      file_contents = File.read(file)
      expect(read_f[0]).to_not eq(Base64.encode64(file_contents))
      expect(read_f.length).to eq(2)
      expect(Base64.decode64(read_f[0])).to eq(Base64.decode64(file_contents))
    end
  end
end
