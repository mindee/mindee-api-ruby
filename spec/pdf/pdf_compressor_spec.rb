# frozen_string_literal: true

require 'mindee'

require_relative '../data'

describe Mindee::PDF::PDFCompressor do
  describe 'The PDF text detection method' do
    it 'should detect text pdf in a PDF file.' do
      text_input = Mindee::Input::Source::PathInputSource.new("#{FILE_TYPES_DIR}/pdf/multipage.pdf")
      expect(Mindee::PDF::PDFTools.source_text?(text_input.io_stream)).to be(true)
    end

    it 'should not detect text pdf in an empty PDF file.' do
      no_text_input = Mindee::Input::Source::PathInputSource.new(
        "#{FILE_TYPES_DIR}/pdf/blank_1.pdf"
      )
      expect(Mindee::PDF::PDFTools.source_text?(no_text_input.io_stream)).to be(false)
    end

    it 'should not detect text pdf in an image file.' do
      image_input = Mindee::Input::Source::PathInputSource.new("#{FILE_TYPES_DIR}/receipt.jpg")
      expect(Mindee::PDF::PDFTools.source_text?(image_input.io_stream)).to be(false)
    end
  end

  describe 'PDF compression' do
    it 'should compress from an input source' do
      input_file_path = "#{V1_DATA_DIR}/products/invoice_splitter/default_sample.pdf"
      output_file_path = "#{ROOT_DATA_DIR}/output/compress_indirect.pdf"
      pdf_input = Mindee::Input::Source::PathInputSource.new(
        "#{V1_DATA_DIR}/products/invoice_splitter/default_sample.pdf"
      )
      pdf_input.compress!(quality: 50)
      File.write(output_file_path, pdf_input.io_stream.read)
      expect(File.size(output_file_path)).to be < File.size(input_file_path)
    end

    it 'should compress from the compressor' do
      input_file_path = "#{V1_DATA_DIR}/products/invoice_splitter/default_sample.pdf"
      output_file_paths = {
        85 => "#{ROOT_DATA_DIR}/output/compressed_direct_85.pdf",
        75 => "#{ROOT_DATA_DIR}/output/compressed_direct_75.pdf",
        50 => "#{ROOT_DATA_DIR}/output/compressed_direct_50.pdf",
        10 => "#{ROOT_DATA_DIR}/output/compressed_direct_10.pdf",
      }
      pdf = File.open(input_file_path)
      output_file_paths.each_pair do |key, value|
        compressed_pdf = Mindee::PDF::PDFCompressor.compress_pdf(pdf, quality: key)
        compressed_pdf.rewind
        File.write(value, compressed_pdf.read)
      end
      expect(File.size(input_file_path)).to be > File.size(output_file_paths[85])
      expect(File.size(output_file_paths[75])).to be < File.size(output_file_paths[85])
      expect(File.size(output_file_paths[50])).to be < File.size(output_file_paths[75])
      expect(File.size(output_file_paths[10])).to be < File.size(output_file_paths[50])
    end

    after(:each) do
      output_dir = "#{ROOT_DATA_DIR}/output"
      FileUtils.rm_f("#{output_dir}/compressed_direct_85.pdf")
      FileUtils.rm_f("#{output_dir}/compressed_direct_75.pdf")
      FileUtils.rm_f("#{output_dir}/compressed_direct_50.pdf")
      FileUtils.rm_f("#{output_dir}/compressed_direct_10.pdf")
      FileUtils.rm_f("#{output_dir}/compress_indirect.pdf")
    end
  end

  describe 'source text PDF compression' do
    it 'should compress if forced' do
      input_file_path = "#{FILE_TYPES_DIR}/pdf/multipage.pdf"
      output_file_path = "#{ROOT_DATA_DIR}/output/compress_with_text.pdf"
      pdf_input = Mindee::Input::Source::PathInputSource.new(input_file_path)
      pdf_input.compress!(quality: 50, force_source_text: true, disable_source_text: false)
      File.write(output_file_path, pdf_input.io_stream.read)
      expect(File.size(output_file_path)).to be > File.size(input_file_path)

      pdf_input.io_stream.rewind
      reader = PDFReader::Reader.new(pdf_input.io_stream)

      text = ''
      reader.pages.each do |original_page|
        receiver = PDFReader::Reader::PageTextReceiver.new
        original_page.walk(receiver)

        receiver.runs.each do |text_run|
          text += text_run.text
        end
      end
      expect(text).to eq('*' * 650)
    end

    after(:each) do
      output_dir = "#{ROOT_DATA_DIR}/output"
      FileUtils.rm_f("#{output_dir}/compress_with_text.pdf")
    end
  end
end
