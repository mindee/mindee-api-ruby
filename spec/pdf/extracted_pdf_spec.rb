# frozen_string_literal: true

require 'mindee'

describe Mindee::PDF::PDFExtractor::ExtractedPDF do
  let(:product_data_dir) { File.join(DATA_DIR, 'products') }
  let(:output_dir) { File.join(DATA_DIR, 'output') }
  let(:file_types_dir) { File.join(DATA_DIR, 'file_types') }
  let(:valid_pdf_path) { "#{product_data_dir}/invoices/invoice.pdf" }
  let(:invalid_pdf_path) { "#{file_types_dir}/receipt.txt" }
  let(:output_path) { "#{output_dir}/sample_output.pdf" }

  before do
    allow(File).to receive(:directory?).and_return(false)
    allow(File).to receive(:exist?).and_return(true)
    allow(File).to receive(:extname).and_return('.pdf')
    allow(File).to receive(:write)
  end

  describe '#initialize' do
    it 'initializes with valid pdf bytes and filename' do
      pdf_stream = File.open(valid_pdf_path, 'r')
      extracted_pdf = described_class.new(pdf_stream, 'invoice.pdf')

      expect(extracted_pdf.pdf_bytes).to eq(pdf_stream)
      expect(extracted_pdf.filename).to eq('invoice.pdf')
    end
  end

  describe '#page_count' do
    it 'raises an error for invalid PDF content' do
      jpg_stream = File.open(invalid_pdf_path, 'r')
      pdf_wrapper = described_class.new(jpg_stream, 'dummy.pdf')

      expect do
        pdf_wrapper.page_count
      end.to raise_error Mindee::Errors::MindeePDFError, %r{Could not retrieve page count}
    end

    it 'returns the correct page count for a valid PDF' do
      pdf_stream = File.open(valid_pdf_path, 'r')
      allow(Mindee::PDF::PDFProcessor).to receive(:open_pdf).and_return(double(pages: [1, 2, 3]))
      pdf_wrapper = described_class.new(pdf_stream, 'invoice.pdf')

      expect(pdf_wrapper.page_count).to eq(3)
    end
  end

  describe '#write_to_file' do
    it 'writes the PDF bytes to a specified file path' do
      pdf_stream = File.open(valid_pdf_path, 'r')
      pdf_wrapper = described_class.new(pdf_stream, 'invoice.pdf')

      expect { pdf_wrapper.write_to_file(output_path) }.not_to raise_error
      expect(File).to have_received(:write).with(output_path, pdf_stream)
    end

    it 'raises an error if the output path is a directory' do
      allow(File).to receive(:directory?).and_return(true)
      pdf_stream = File.open(valid_pdf_path, 'r')
      pdf_wrapper = described_class.new(pdf_stream, 'invoice.pdf')

      expect do
        pdf_wrapper.write_to_file(output_path)
      end.to raise_error Mindee::Errors::MindeePDFError, %r{Provided path is not a file}
    end

    it 'raises an error if the save path is invalid' do
      allow(File).to receive(:exist?).and_return(false)
      pdf_stream = File.open(valid_pdf_path, 'r')
      pdf_wrapper = described_class.new(pdf_stream, 'invoice.pdf')

      expect do
        pdf_wrapper.write_to_file(output_path)
      end.to raise_error Mindee::Errors::MindeePDFError, %r{Invalid save path provided}
    end
  end

  describe '#as_input_source' do
    it 'returns a BytesInputSource object with correct attributes' do
      pdf_stream = StringIO.new('pdf content')
      input_source_double = double('BytesInputSource', content: 'pdf content', filename: 'invoice.pdf')

      allow(Mindee::Input::Source::BytesInputSource).to receive(:new).and_return(input_source_double)

      pdf_wrapper = described_class.new(pdf_stream, 'invoice.pdf')
      input_source = pdf_wrapper.as_input_source

      expect(input_source.content).to eq('pdf content')
      expect(input_source.filename).to eq('invoice.pdf')
    end
  end
end
