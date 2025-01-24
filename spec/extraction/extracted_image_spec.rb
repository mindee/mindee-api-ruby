# frozen_string_literal: true

require 'mindee'
require 'tempfile'
require 'pathname'
require 'stringio'
require 'mini_magick'
require_relative '../data'

describe Mindee::Extraction::ExtractedImage do
  let(:dummy_io_content) { 'This is a test file content.' }
  let(:input_source) do
    Mindee::Input::Source::PathInputSource.new("#{DATA_DIR}/products/invoices/default_sample.jpg")
  end

  context 'An extracted image' do
    it 'should initialize correctly with valid inputs' do
      page_id = 1
      element_id = 2
      extracted_image = Mindee::Extraction::ExtractedImage.new(input_source, page_id, element_id)

      expect(extracted_image.buffer).to_not be(nil)
      expect(extracted_image.page_id).to eq(page_id)
      expect(extracted_image.element_id).to eq(element_id)
      expect(extracted_image.internal_file_name).to eq("default_sample_p#{page_id}_#{element_id}.jpg")
    end

    it 'should handle nil element_id by setting it to 0' do
      page_id = 1
      extracted_image = Mindee::Extraction::ExtractedImage.new(input_source, page_id, nil)

      expect(extracted_image.element_id).to eq(0)
    end

    it 'should save the buffer to a file with valid format' do
      page_id = 1
      element_id = 2
      extracted_image = Mindee::Extraction::ExtractedImage.new(input_source, page_id, element_id)

      random_sequence = Array.new(8) { rand(0..9) }.join
      extracted_image.save_to_file("#{DATA_DIR}/output/temp-#{random_sequence}.jpg", 'jpg')
      expect(File.exist?("#{DATA_DIR}/output/temp-#{random_sequence}.jpg")).to be(true)
      expect(File.read("#{DATA_DIR}/output/temp-#{random_sequence}.jpg")).to_not be_empty
      File.delete("#{DATA_DIR}/output/temp-#{random_sequence}.jpg")
      expect(File.exist?("#{DATA_DIR}/output/temp-#{random_sequence}.jpg")).to be(false)
    end

    it 'should infer file format from extension if not provided' do
      page_id = 1
      element_id = 2
      extracted_image = Mindee::Extraction::ExtractedImage.new(input_source, page_id, element_id)

      Tempfile.create(['output', '.png']) do |tempfile|
        extracted_image.save_to_file(tempfile.path)
        expect(File.exist?(tempfile.path)).to be(true)
        expect(File.read(tempfile.path)).to_not be_empty
      end
    end

    it 'should raise an error for invalid file format during save' do
      page_id = 1
      element_id = 2
      extracted_image = Mindee::Extraction::ExtractedImage.new(input_source, page_id, element_id)

      Tempfile.create(['output', '.']) do |tempfile|
        expect do
          extracted_image.save_to_file(tempfile.path)
        end.to raise_error(Mindee::Errors::MindeeImageError)
      end
    end

    it 'should raise an error for invalid path during save' do
      page_id = 1
      element_id = 2
      extracted_image = Mindee::Extraction::ExtractedImage.new(input_source, page_id, element_id)

      invalid_path = '/invalid/path/output.jpg'
      expect do
        extracted_image.save_to_file(invalid_path)
      end.to raise_error(Mindee::Errors::MindeeImageError)
    end

    it 'should return a valid source object from as_source' do
      page_id = 1
      element_id = 2
      extracted_image = Mindee::Extraction::ExtractedImage.new(input_source, page_id, element_id)

      source_object = extracted_image.as_source

      expect(source_object).to be_a(Mindee::Input::Source::BytesInputSource)
      expect(source_object.filename).to eq(extracted_image.internal_file_name)
    end

    it 'should raise an error when MiniMagick fails during save' do
      allow(MiniMagick::Image).to receive(:read).and_raise(StandardError)

      extracted_image = Mindee::Extraction::ExtractedImage.new(input_source, 1, 2)

      Tempfile.create(['output', '.jpg']) do |tempfile|
        expect do
          extracted_image.save_to_file(tempfile.path, 'jpg')
        end.to raise_error(Mindee::Errors::MindeeImageError, %r{Could not save file})
      end
    end
  end
end
