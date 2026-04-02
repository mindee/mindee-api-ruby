# frozen_string_literal: true

require 'mindee'

describe Mindee::PDF::ExtractedPDF do
  let(:output_dir) { File.join(V1_DATA_DIR, 'output') }
  let(:valid_pdf_path) { "#{V1_PRODUCT_DATA_DIR}/invoices/invoice.pdf" }
  let(:invalid_pdf_path) { "#{FILE_TYPES_DIR}/receipt.txt" }
  let(:output_path) { "#{output_dir}/sample_output.pdf" }

  before do
    allow(File).to receive(:directory?).and_return(false)
    allow(File).to receive(:exist?).and_return(true)
    allow(File).to receive(:extname).and_return('.pdf')
    allow(File).to receive(:binwrite)
  end

  describe '#initialize' do
    it 'initializes with valid pdf bytes and filename' do
      File.open(valid_pdf_path, 'r') do |pdf_stream|
        extracted_pdf = described_class.new(pdf_stream, 'invoice.pdf')
        expect(extracted_pdf.pdf_bytes).to be_a(StringIO)
        pdf_stream.rewind
        extracted_pdf.pdf_bytes.rewind
        expect(extracted_pdf.pdf_bytes.read).to eq(pdf_stream.read)

        expect(extracted_pdf.filename).to eq('invoice.pdf')
      end
    end
  end

  describe '#page_count' do
    it 'raises an error for invalid PDF content' do
      File.open(invalid_pdf_path, 'r') do |jpg_stream|
        pdf_wrapper = described_class.new(jpg_stream, 'dummy.pdf')

        expect do
          pdf_wrapper.page_count
        end.to raise_error Mindee::Error::MindeePDFError, %r{Could not retrieve page count}
      end
    end

    it 'returns the correct page count for a valid PDF' do
      File.open(valid_pdf_path, 'r') do |pdf_stream|
        allow(Mindee::PDF::PDFProcessor).to receive(:open_pdf).and_return(double(pages: [1, 2, 3]))
        pdf_wrapper = described_class.new(pdf_stream, 'invoice.pdf')

        expect(pdf_wrapper.page_count).to eq(3)
      end
    end
  end

  describe '#write_to_file' do
    it 'writes the PDF bytes to a specified file path' do
      File.open(valid_pdf_path, 'r') do |pdf_stream|
        expected_pdf_content = pdf_stream.read
        pdf_stream.rewind
        pdf_wrapper = described_class.new(pdf_stream, 'invoice.pdf')

        expect { pdf_wrapper.write_to_file(output_path) }.not_to raise_error
        expect(File).to have_received(:binwrite).with(output_path, expected_pdf_content)
      end
    end

    it 'raises an error if the output path is a directory' do
      allow(File).to receive(:directory?).and_return(true)
      File.open(valid_pdf_path, 'r') do |pdf_stream|
        pdf_wrapper = described_class.new(pdf_stream, 'invoice.pdf')

        expect do
          pdf_wrapper.write_to_file(output_path)
        end.to raise_error Mindee::Error::MindeePDFError, %r{Provided path is not a file}
      end
    end

    it 'raises an error if the save path is invalid' do
      allow(File).to receive(:exist?).and_return(false)
      File.open(valid_pdf_path, 'r') do |pdf_stream|
        pdf_wrapper = described_class.new(pdf_stream, 'invoice.pdf')

        expect do
          pdf_wrapper.write_to_file(output_path)
        end.to raise_error Mindee::Error::MindeePDFError, %r{Invalid save path provided}
      end
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
