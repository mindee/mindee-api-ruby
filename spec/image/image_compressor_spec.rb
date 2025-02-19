# frozen_string_literal: true

require 'mindee'

require_relative '../data'

describe Mindee::Image::ImageCompressor do
  describe 'Image Quality Compression' do
    let(:input_receipt_path) { "#{DATA_DIR}/file_types/receipt.jpg" }
    let(:output_dir) { "#{DATA_DIR}/output/" }

    it 'should compress the image from input source' do
      receipt_input = Mindee::Input::Source::PathInputSource.new(input_receipt_path)
      receipt_input.compress!(quality: 80) # NOTE: base jpg quality is ~81

      FileUtils.mkdir_p(File.dirname("#{output_dir}compress_indirect.jpg"))
      File.write("#{output_dir}compress_indirect.jpg", receipt_input.io_stream.read)

      initial_file_size = File.size(input_receipt_path)
      compressed_file_size = File.size(output_dir)

      expect(compressed_file_size).to be < initial_file_size
    end

    it 'should compress the image with various quality levels' do
      receipt_input = Mindee::Input::Source::PathInputSource.new(input_receipt_path)

      compresses = [
        Mindee::Image::ImageCompressor.compress_image(receipt_input.io_stream, quality: 100),
        Mindee::Image::ImageCompressor.compress_image(receipt_input.io_stream), # default quality
        Mindee::Image::ImageCompressor.compress_image(receipt_input.io_stream, quality: 50),
        Mindee::Image::ImageCompressor.compress_image(receipt_input.io_stream, quality: 10),
        Mindee::Image::ImageCompressor.compress_image(receipt_input.io_stream, quality: 1),
      ]

      output_files = [
        "#{output_dir}/compress100.jpg",
        "#{output_dir}/compress85.jpg",
        "#{output_dir}/compress50.jpg",
        "#{output_dir}/compress10.jpg",
        "#{output_dir}/compress1.jpg",
      ]

      compresses.zip(output_files).each do |compressed, output_file|
        File.write(output_file, compressed.read)
      end

      initial_file_size = File.size(input_receipt_path)
      rendered_file_sizes = output_files.map { |file| File.size(file) }

      expect(initial_file_size).to be < rendered_file_sizes[0]
      expect(initial_file_size).to be < rendered_file_sizes[1]
      expect(rendered_file_sizes[1]).to be > rendered_file_sizes[2]
      expect(rendered_file_sizes[2]).to be > rendered_file_sizes[3]
      expect(rendered_file_sizes[3]).to be > rendered_file_sizes[4]
    end

    after(:each) do
      FileUtils.rm_f("#{output_dir}/compress100.jpg")
      FileUtils.rm_f("#{output_dir}/compress85.jpg")
      FileUtils.rm_f("#{output_dir}/compress50.jpg")
      FileUtils.rm_f("#{output_dir}/compress10.jpg")
      FileUtils.rm_f("#{output_dir}/compress1.jpg")
      FileUtils.rm_f("#{output_dir}/compress_indirect.jpg")
    end
  end
end
