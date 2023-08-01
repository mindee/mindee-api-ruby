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
      expect(read_f[1]).to eq(Base64.encode64(open(file).read))
    end
  end

  context 'A jpga input file' do
    it 'should be converted as a valid byte64 string' do
      file = File.join(DATA_DIR, 'receipt/receipt.jpga')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_document
      expect(read_f[1]).to eq(Base64.encode64(open(file).read))
    end
  end


  context 'A heic input file' do
    it 'should be converted as a valid byte64 string' do
      file = File.join(DATA_DIR, 'receipt/receipt.heic')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_document
      expect(read_f[1]).to eq(Base64.encode64(open(file).read))
    end
  end


  context 'A tif input file' do
    it 'should be converted as a valid byte64 string' do
      file = File.join(DATA_DIR, 'receipt/receipt.tif')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_document
      expect(read_f[1]).to eq(Base64.encode64(open(file).read))
    end
  end


  context 'A tiff input file' do
    it 'should be converted as a valid byte64 string' do
      file = File.join(DATA_DIR, 'receipt/receipt.tiff')
      input = Mindee::Input::Source::PathInputSource.new(file)
      read_f = input.read_document
      expect(read_f[1]).to eq(Base64.encode64(open(file).read))
    end
  end


  context 'A txt input file' do
    it 'should be converted as a valid byte64 string' do
      file = File.join(DATA_DIR, 'receipt/receipt.txt')
      input = Mindee::Input::Source::Base64InputSource.new(open(file).read, "receipt.txt")
      read_f = input.read_document
      expect(read_f[1].gsub("\n",'')).to eq(open(file).read.gsub("\n",''))
    end
  end

  
end
