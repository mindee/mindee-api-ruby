# frozen_string_literal: true

require 'json'
require 'mindee/product'

require_relative '../../data'

DIR_EU_LICENSE_PLATE_V1 = File.join(DATA_DIR, 'eu', 'license_plate', 'response_v1').freeze

describe Mindee::Product::EU::LicensePlateV1 do
  context 'A License Plate V1' do
    it 'should load an empty document prediction' do
      response = load_json(DIR_EU_LICENSE_PLATE_V1, 'empty.json')
      inference = Mindee::Document.new(Mindee::Product::EU::LicensePlateV1, response['document']).inference
      expect(inference.product.type).to eq('standard')
    end

    it 'should load a complete document prediction' do
      to_string = read_file(DIR_EU_LICENSE_PLATE_V1, 'summary_full.rst')
      response = load_json(DIR_EU_LICENSE_PLATE_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Product::EU::LicensePlateV1, response['document'])
      expect(document.to_s).to eq(to_string)
    end

    it 'should load a complete page 0 prediction' do
      to_string = read_file(DIR_EU_LICENSE_PLATE_V1, 'summary_page0.rst')
      response = load_json(DIR_EU_LICENSE_PLATE_V1, 'complete.json')
      document = Mindee::Document.new(Mindee::Product::EU::LicensePlateV1, response['document'])
      page = document.inference.pages[0]
      expect(page.to_s).to eq(to_string)
    end
  end
end
