# frozen_string_literal: true

require 'json'
require 'mindee'
require_relative 'extras_utils'

describe 'cropper extra do' do
  let(:cropper_dir) do
    File.join(EXTRAS_DIR, 'cropper')
  end

  let(:complete_doc) do
    complete_doc_file = File.read(File.join(cropper_dir, 'complete.json'))
    complete_doc_json = JSON.parse(complete_doc_file)
    Mindee::Parsing::Common::Document.new(Mindee::Product::Receipt::ReceiptV5, complete_doc_json['document'])
  end

  describe 'cropper extra' do
    it 'has correct cropper extra data' do
      expect(complete_doc.inference.pages[0].extras.cropper.croppings.count).to eq(1)

      cropping = complete_doc.inference.pages[0].extras.cropper.croppings[0]
      expect(cropping).to be_a Mindee::Parsing::Standard::PositionField

      expect(cropping.bounding_box[0].x).to be_within(0.001).of(0.057)
      expect(cropping.bounding_box[0].y).to be_within(0.001).of(0.008)
      expect(cropping.bounding_box[1].x).to be_within(0.001).of(0.846)
      expect(cropping.bounding_box[1].y).to be_within(0.001).of(0.008)
      expect(cropping.bounding_box[2].x).to be_within(0.001).of(0.846)
      expect(cropping.bounding_box[2].y).to be_within(0.001).of(1.0)
      expect(cropping.bounding_box[3].x).to be_within(0.001).of(0.057)
      expect(cropping.bounding_box[3].y).to be_within(0.001).of(1.0)

      expect(cropping.polygon.count).to eq(24)
      expect(cropping.quadrangle.count).to eq(4)
      expect(cropping.rectangle.count).to eq(4)
    end
  end
end
