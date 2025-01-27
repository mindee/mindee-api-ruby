# frozen_string_literal: true

require 'mindee'
require 'rspec'

describe 'Invoice extraction' do
  let(:product_data_dir) { File.join(DATA_DIR, 'products') }

  it 'should extract a PDF from an image' do
    jpg_stream = File.open("#{product_data_dir}/invoices/default_sample.jpg", 'r')
    pdf_wrapper = Mindee::Image::PdfExtractor::ExtractedPdf.new(jpg_stream, 'dummy.pdf')
    expect do
      pdf_wrapper.page_count
    end.to raise_error Mindee::Errors::MindeePDFError
  end
end
