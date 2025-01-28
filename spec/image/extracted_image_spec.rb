# frozen_string_literal: true

require 'mindee'
require 'pathname'
require 'fileutils'
require 'mini_magick'
require_relative '../data'

describe Mindee::Image::ExtractedImage do
  let(:file_path) do
    File.join(DATA_DIR, 'products', 'invoices', 'default_sample.jpg')
  end
  let(:input_source) do
    Mindee::Input::Source::PathInputSource.new(file_path)
  end
  let(:page_id) { 1 }
  let(:element_id) { 42 }
  let(:output_dir) { "#{DATA_DIR}/output" }

  describe '#initialize' do
    it 'initializes with correct attributes' do
      extracted_image = described_class.new(input_source, page_id, element_id)

      expect(extracted_image.page_id).to eq(page_id)
      expect(extracted_image.element_id).to eq(element_id)
      expect(extracted_image.internal_file_name).to eq('default_sample_p1_42.jpg')

      # NOTE: ruby messes up the formatting of binary strings, I don't think it worth it to correct this behavior, but
      # the result is that we have to remove them from the comparisons.
      input_source.io_stream.rewind
      source_content = extracted_image.buffer.read.gsub("\r", '').gsub("\n", '')
      input_content = input_source.io_stream.read.gsub("\r", '').gsub("\n", '')

      expect(source_content).to eq(input_content)

      input_source.io_stream.rewind
    end

    it 'defaults element_id to 0 if nil is provided' do
      extracted_image = described_class.new(input_source, page_id, nil)

      expect(extracted_image.element_id).to eq(0)
    end

    it 'appends .jpg extension for PDF input sources' do
      allow(input_source).to receive(:pdf?).and_return(true)

      extracted_image = described_class.new(input_source, page_id, element_id)

      expect(extracted_image.internal_file_name).to eq('default_sample_p1_42.jpg')
    end
  end

  describe '#write_to_file' do
    it 'saves the buffer to a file with the correct format' do
      extracted_image = described_class.new(input_source, page_id, element_id)
      output_path = "#{output_dir}/output_test.jpg"

      extracted_image.write_to_file(output_path)

      expect(File.exist?(output_path)).to be true
      expect(File.size(output_path)).to be > 0
    end

    it 'raises an error if file format is invalid' do
      extracted_image = described_class.new(input_source, page_id, element_id)
      invalid_output_path = "#{output_dir}/output_test"

      expect do
        extracted_image.write_to_file(invalid_output_path)
      end.to raise_error(Mindee::Errors::MindeeImageError, %r{Invalid file format})
    end

    it 'raises an error if the file cannot be saved' do
      extracted_image = described_class.new(input_source, page_id, element_id)
      invalid_output_path = '/invalid/path/output_test.jpg'

      expect do
        extracted_image.write_to_file(invalid_output_path)
      end.to raise_error(Mindee::Errors::MindeeImageError)
    end
  end

  describe '#as_source' do
    it 'returns a BytesInputSource with the correct content and filename' do
      extracted_image = described_class.new(input_source, page_id, element_id)

      source = extracted_image.as_source

      expect(source).to be_a(Mindee::Input::Source::BytesInputSource)
      expect(source.filename).to eq('default_sample_p1_42.jpg')
      source.io_stream.rewind

      input_source.io_stream.rewind
      source_content = source.io_stream.read.gsub("\r", '').gsub("\n", '')
      input_content = input_source.io_stream.read.gsub("\r", '').gsub("\n", '')

      expect(source_content).to eq(input_content)

      input_source.io_stream.rewind
    end

    it 'should raise an error when MiniMagick fails during save' do
      allow(MiniMagick::Image).to receive(:read).and_raise(StandardError)

      extracted_image = Mindee::Image::ExtractedImage.new(input_source, 1, 2)

      Tempfile.create(['output', '.jpg']) do |tempfile|
        expect do
          extracted_image.write_to_file(tempfile.path, 'jpg')
        end.to raise_error(Mindee::Errors::MindeeImageError, %r{Could not save file})
      end
    end

    after(:each) do
      FileUtils.rm_f("#{output_dir}/output_test.jpg")
    end
  end
end
