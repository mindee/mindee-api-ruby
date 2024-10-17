# frozen_string_literal: true

require 'mindee'
require 'mindee/input/sources'
require 'pdf-reader'

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

  context 'A broken fixable PDF' do
    mindee_client = Mindee::Client.new(api_key: 'invalid-api-key')
    it 'Should not raise a mime error' do
      expect do
        mindee_client.source_from_path("#{DATA_DIR}/file_types/pdf/broken_fixable.pdf", fix_pdf: true)
      end.not_to raise_error
    end
  end

  context 'A broken unfixable PDF' do
    mindee_client = Mindee::Client.new(api_key: 'invalid-api-key')
    it 'Should raise an error' do
      expect do
        mindee_client.source_from_path("#{DATA_DIR}/file_types/pdf/broken_unfixable.pdf", fix_pdf: true)
      end.to raise_error Mindee::Input::Source::UnfixablePDFError
    end
  end

  context 'A broken fixable invoice PDF' do
    mindee_client = Mindee::Client.new(api_key: 'invalid-api-key')
    it 'Should send correct results' do
      source_doc_original = mindee_client.source_from_path("#{DATA_DIR}/products/invoices/invoice.pdf")
      expect do
        source_doc_fixed = mindee_client.source_from_path("#{DATA_DIR}/file_types/pdf/broken_invoice.pdf",
                                                          fix_pdf: true)
        expect(source_doc_fixed.read_document[1].to_s).to eq(source_doc_original.read_document[1].to_s)
      end.not_to raise_error
    end
  end

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
        "#{output_dir}/compress75.jpg",
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
      FileUtils.rm_f("#{output_dir}/compress75.jpg")
      FileUtils.rm_f("#{output_dir}/compress50.jpg")
      FileUtils.rm_f("#{output_dir}/compress10.jpg")
      FileUtils.rm_f("#{output_dir}/compress1.jpg")
    end
  end

  describe 'The PDF text detection method' do
    it 'should detect text pdf in a PDF file.' do
      text_input = Mindee::Input::Source::PathInputSource.new("#{DATA_DIR}/file_types/pdf/multipage.pdf")
      expect(Mindee::PDF::PDFTools.source_text?(text_input.io_stream)).to be(true)
    end

    it 'should not detect text pdf in an empty PDF file.' do
      no_text_input = Mindee::Input::Source::PathInputSource.new(
        "#{DATA_DIR}/products/invoice_splitter/default_sample.pdf"
      )
      expect(Mindee::PDF::PDFTools.source_text?(no_text_input.io_stream)).to be(false)
    end

    it 'should not detect text pdf in an image file.' do
      image_input = Mindee::Input::Source::PathInputSource.new("#{DATA_DIR}/file_types/receipt.jpg")
      expect(Mindee::PDF::PDFTools.source_text?(image_input.io_stream)).to be(false)
    end
  end

  describe 'PDF compression' do
    it 'should compress from an input source' do
      input_file_path = "#{DATA_DIR}/products/invoice_splitter/default_sample.pdf"
      output_file_path = "#{DATA_DIR}/output/compress_indirect.pdf"
      pdf_input = Mindee::Input::Source::PathInputSource.new("#{DATA_DIR}/products/invoice_splitter/default_sample.pdf")
      pdf_input.compress!(quality: 50)
      File.write(output_file_path, pdf_input.io_stream.read)
      expect(File.size(output_file_path)).to be < File.size(input_file_path)
    end

    it 'should compress from the compressor' do
      input_file_path = "#{DATA_DIR}/products/invoice_splitter/default_sample.pdf"
      output_file_paths = {
        85 => "#{DATA_DIR}/output/compressed_direct_85.pdf",
        75 => "#{DATA_DIR}/output/compressed_direct_75.pdf",
        50 => "#{DATA_DIR}/output/compressed_direct_50.pdf",
        10 => "#{DATA_DIR}/output/compressed_direct_10.pdf",
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
  end
  describe 'source text PDF compression' do
    it 'should compress if forced' do
      input_file_path = "#{DATA_DIR}/file_types/pdf/multipage.pdf"
      output_file_path = "#{DATA_DIR}/output/compress_with_text.pdf"
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
  end
end
