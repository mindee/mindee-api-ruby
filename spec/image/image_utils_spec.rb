# frozen_string_literal: true

# spec/image_utils_spec.rb
require 'rspec'
require 'mini_magick'
require 'stringio'
require 'mindee'

describe Mindee::Image::ImageUtils do
  let(:sample_image_path) { "#{DATA_DIR}/file_types/receipt.jpg" }
  let(:sample_image) { MiniMagick::Image.open(sample_image_path) }

  describe 'Image utility module' do
    it 'converts StringIO to MiniMagick::Image' do
      string_io = StringIO.new(File.read(sample_image_path))
      result = Mindee::Image::ImageUtils.to_image(string_io)
      expect(result).to be_a(MiniMagick::Image)
    end

    it 'returns the same MiniMagick::Image object if passed as input' do
      result = Mindee::Image::ImageUtils.to_image(sample_image)
      expect(result).to eq(sample_image)
    end

    it 'raises an error for invalid input types' do
      expect do
        Mindee::Image::ImageUtils.to_image(123)
      end.to raise_error(Mindee::Errors::MindeeImageError, %r{Expected an I/O object or a MiniMagick::Image})
    end
  end

  describe '.image_to_stringio' do
    it 'converts MiniMagick image to StringIO' do
      result = Mindee::Image::ImageUtils.image_to_stringio(sample_image)
      expect(result).to be_a(StringIO)
    end

    it 'sets the format of the image correctly' do
      result = Mindee::Image::ImageUtils.image_to_stringio(sample_image, 'PNG')
      expect(result.string[1..3]).to eq('PNG')
    end
  end

  describe '.calculate_new_dimensions' do
    it 'returns original dimensions if no max_width or max_height is provided' do
      result = Mindee::Image::ImageUtils.calculate_new_dimensions(sample_image)
      expect(result).to eq([sample_image.width, sample_image.height])
    end

    it 'calculates new dimensions based on max_width and max_height' do
      result = Mindee::Image::ImageUtils.calculate_new_dimensions(sample_image, max_width: 100, max_height: 100)
      expect(result[0]).to be <= 100
      expect(result[1]).to be <= 100
    end

    it 'raises an error if the original image is nil' do
      expect do
        Mindee::Image::ImageUtils.calculate_new_dimensions(nil)
      end.to raise_error(Mindee::Errors::MindeeImageError, %r{Provided image could not be processed for resizing})
    end
  end

  describe '.calculate_dimensions_from_media_box' do
    it 'returns dimensions from media box if provided' do
      media_box = [0, 0, 300, 400]
      result = Mindee::Image::ImageUtils.calculate_dimensions_from_media_box(sample_image, media_box)
      expect(result).to eq([300, 400])
    end

    it 'falls back to image dimensions if media box is nil or empty' do
      result = Mindee::Image::ImageUtils.calculate_dimensions_from_media_box(sample_image, nil)
      expect(result).to eq([sample_image.width.to_i, sample_image.height.to_i])
    end
  end

  describe '.pdf_to_magick_image' do
    it 'raises an error if the PDF stream is invalid' do
      invalid_pdf_stream = StringIO.new('invalid data')
      # Adjust based on actual error raised by MiniMagick for invalid data.
      expect do
        Mindee::Image::ImageUtils.pdf_to_magick_image(invalid_pdf_stream, 75)
      end.to raise_error(MiniMagick::Error)
    end
  end
end
