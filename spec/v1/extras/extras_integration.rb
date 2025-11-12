# frozen_string_literal: true

require 'json'
require 'mindee'
require_relative 'extras_utils'
require_relative '../../data'
require_relative '../../test_utilities'

describe 'cropper extra' do
  let(:invoice_path) { File.join(V1_DATA_DIR, 'products', 'invoices', 'default_sample.jpg') }
  let(:client) { Mindee::Client.new }
  it 'should send correctly' do
    cropper_extra = Mindee::Input::Source::PathInputSource.new(
      File.join(invoice_path)
    )
    cropper_result = client.parse(cropper_extra, Mindee::Product::Invoice::InvoiceV4, options: { cropper: true },
                                                                                      enqueue: false)
    expect(cropper_result.document.inference.pages[0].extras.cropper).to_not be_nil
  end
end

describe 'Full Text OCR extra' do
  let(:invoice_path) { File.join(V1_DATA_DIR, 'products', 'invoices', 'default_sample.jpg') }
  let(:client) { Mindee::Client.new }
  it 'should send correctly' do
    full_text_ocr_input = Mindee::Input::Source::PathInputSource.new(
      File.join(invoice_path)
    )
    full_text_ocr_result = client.parse(
      full_text_ocr_input,
      Mindee::Product::InternationalId::InternationalIdV2,
      options: { full_text: true }
    )
    expect(full_text_ocr_result.document.extras.full_text_ocr).to_not be_nil
  end
end
