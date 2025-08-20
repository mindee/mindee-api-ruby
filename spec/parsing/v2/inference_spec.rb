# frozen_string_literal: true

require 'mindee'

RSpec.describe 'inference' do
  let(:v2_data_dir) { File.join(DATA_DIR, 'v2') }
  let(:findoc_path) { File.join(v2_data_dir, 'products', 'financial_document') }
  let(:inference_path) { File.join(v2_data_dir, 'inference') }
  let(:deep_nested_field_path) { File.join(inference_path, 'deep_nested_fields.json') }
  let(:standard_field_path) { File.join(inference_path, 'standard_field_types.json') }
  let(:standard_field_rst_path) { File.join(inference_path, 'standard_field_types.rst') }
  let(:location_field_path) { File.join(findoc_path, 'complete_with_coordinates.json') }
  let(:raw_text_path) { File.join(inference_path, 'raw_texts.json') }
  let(:blank_path) { File.join(findoc_path, 'blank.json') }
  let(:complete_path) { File.join(findoc_path, 'complete.json') }

  def load_v2_inference(resource_path)
    local_response = Mindee::Input::LocalResponse.new(resource_path)
    local_response.deserialize_response(Mindee::Parsing::V2::InferenceResponse)
  end

  simple_field = Mindee::Parsing::V2::Field::SimpleField
  object_field = Mindee::Parsing::V2::Field::ObjectField
  list_field   = Mindee::Parsing::V2::Field::ListField
  field_conf   = Mindee::Parsing::V2::Field::FieldConfidence

  describe 'simple' do
    it 'loads a blank inference with valid properties' do
      response = load_v2_inference(blank_path)
      fields = response.inference.result.fields

      expect(fields).not_to be_empty
      expect(fields.size).to eq(21)
      expect(fields).to have_key('taxes')
      expect(fields['taxes']).not_to be_nil
      expect(fields['taxes']).to be_a(list_field)

      expect(fields['supplier_address']).not_to be_nil
      expect(fields['supplier_address']).to be_a(object_field)

      fields.each_value do |entry|
        next if entry.is_a?(simple_field) && entry.value.nil?

        case entry
        when simple_field
          expect(entry.value).not_to be_nil
        when object_field
          expect(entry.fields).not_to be_nil
        when list_field
          expect(entry.items).not_to be_nil
        else
          raise "Unknown field type: #{entry.class}"
        end
      end
    end

    it 'loads a complete inference with valid properties' do
      response = load_v2_inference(complete_path)
      inf = response.inference

      expect(inf).not_to be_nil
      expect(inf.id).to eq('12345678-1234-1234-1234-123456789abc')

      model = inf.model
      expect(model).not_to be_nil
      expect(model.id).to eq('12345678-1234-1234-1234-123456789abc')

      file = inf.file
      expect(file).not_to be_nil
      expect(file.name).to eq('complete.jpg')
      expect(file.file_alias).to be_nil
      expect(file.page_count).to eq(1)
      expect(file.mime_type).to eq('image/jpeg')

      fields = inf.result.fields
      expect(fields).not_to be_empty
      expect(fields.size).to eq(21)

      date_field = fields['date']
      expect(date_field).to be_a(simple_field)
      expect(date_field.value).to eq('2019-11-02')

      expect(fields).to have_key('taxes')
      taxes = fields['taxes']
      expect(taxes).to be_a(list_field)

      taxes_list = taxes
      expect(taxes_list.items.length).to eq(1)
      expect(taxes_list.to_s).to be_a(String)
      expect(taxes_list.to_s).to_not be_empty

      first_tax_item = taxes_list.items.first
      expect(first_tax_item).to be_a(object_field)

      expect(fields).to have_key('line_items')
      expect(fields['line_items']).not_to be_nil
      expect(fields['line_items']).to be_a(list_field)
      expect(fields['line_items'][0]).to be_a(object_field)
      expect(fields['line_items'][0]['quantity'].value).to eq(1.0)

      expect(fields).to have_key('line_items')
      expect(fields['line_items']).not_to be_nil
      expect(fields['line_items']).to be_a(list_field)
      expect(fields['line_items'][0]).to be_a(object_field)
      expect(fields['line_items'][0]['quantity'].value).to eq(1.0)

      tax_item_obj = first_tax_item
      expect(tax_item_obj.fields.size).to eq(3)

      base_field = tax_item_obj.fields['base']
      expect(base_field).to be_a(simple_field)
      expect(base_field.value).to eq(31.5)

      expect(fields).to have_key('supplier_address')
      supplier_address = fields['supplier_address']
      expect(supplier_address).to be_a(object_field)

      supplier_obj = supplier_address
      country_field = supplier_obj.fields['country']
      expect(country_field).to be_a(simple_field)
      expect(country_field.value).to eq('USA')
      expect(country_field.to_s).to eq('USA')
      expect(supplier_address.to_s).to be_a(String)
      expect(supplier_address.to_s).to_not be_empty

      customer_addr = fields['customer_address']
      expect(customer_addr).to be_a(object_field)
      city_field = customer_addr.fields['city']
      expect(city_field).to be_a(simple_field)
      expect(city_field.value).to eq('New York')

      expect(inf.result.options).to be_nil
    end
  end

  describe 'nested' do
    it 'loads a deep nested object' do
      response = load_v2_inference(deep_nested_field_path)
      fields = response.inference.result.fields

      expect(fields['field_simple']).to be_a(simple_field)
      expect(fields['field_object']).to be_a(object_field)

      field_object = fields['field_object']
      lvl1 = field_object.fields

      expect(lvl1['sub_object_list']).to be_a(list_field)
      expect(lvl1['sub_object_object']).to be_a(object_field)

      sub_object_object = lvl1['sub_object_object']
      lvl2 = sub_object_object.fields

      expect(lvl2['sub_object_object_sub_object_list']).to be_a(list_field)

      nested_list = lvl2['sub_object_object_sub_object_list']
      expect(nested_list.items).not_to be_empty
      expect(nested_list.items.first).to be_a(object_field)

      first_item_obj = nested_list.items.first
      deep_simple = first_item_obj.fields['sub_object_object_sub_object_list_simple']

      expect(deep_simple).to be_a(simple_field)
      expect(deep_simple.value).to eq('value_9')
    end
  end

  describe 'standard field types' do
    it 'recognizes all field variants' do
      response = load_v2_inference(standard_field_path)
      fields = response.inference.result.fields

      expect(fields['field_simple_string']).to be_a(simple_field)
      expect(fields['field_simple_string'].value).to eq('field_simple_string-value')

      expect(fields['field_simple_float']).to be_a(simple_field)
      expect(fields['field_simple_float'].value).to eq(1.1)

      expect(fields['field_simple_int']).to be_a(simple_field)
      expect(fields['field_simple_int'].value).to eq(12.0)

      expect(fields['field_simple_zero']).to be_a(simple_field)
      expect(fields['field_simple_zero'].value).to eq(0)

      expect(fields['field_simple_bool']).to be_a(simple_field)
      expect(fields['field_simple_bool'].value).to eq(true)

      expect(fields['field_simple_null']).to be_a(simple_field)
      expect(fields['field_simple_null'].value).to be_nil

      expect(fields['field_object']).to be_a(object_field)
      expect(fields['field_simple_list']).to be_a(list_field)
      expect(fields['field_object_list']).to be_a(list_field)
    end
  end

  describe 'options' do
    it 'exposes raw texts' do
      response = load_v2_inference(raw_text_path)
      opts = response.inference.result.options

      expect(opts).not_to be_nil
      raw_texts =
        if opts.respond_to?(:raw_texts)
          opts.raw_texts
        elsif opts.respond_to?(:get_raw_texts)
          opts.get_raw_texts
        else
          []
        end

      expect(raw_texts).to be_a(Array)
      expect(raw_texts.length).to eq(2)

      first = raw_texts.first
      page = first.respond_to?(:page) ? first.page : first[:page]
      content = first.respond_to?(:content) ? first.content : first[:content]

      expect(page).to eq(0)
      expect(content).to eq('This is the raw text of the first page...')
    end
  end

  describe 'rst display' do
    it 'is properly exposed' do
      response = load_v2_inference(standard_field_path)
      rst_string = File.read(standard_field_rst_path, encoding: 'UTF-8')

      expect(response.inference).not_to be_nil
      expect(response.inference.to_s).to eq(rst_string)
    end
  end

  describe 'field locations and confidence' do
    it 'are properly exposed' do
      response = load_v2_inference(location_field_path)

      expect(response.inference).not_to be_nil

      date_field = response.inference.result.fields['date']
      expect(date_field).to be_a(simple_field)
      expect(date_field.locations).to be_an(Array)
      expect(date_field.locations[0]).not_to be_nil
      expect(date_field.locations[0].page).to eq(0)

      polygon = date_field.locations[0].polygon
      expect(polygon[0].length).to eq(2)

      expect(polygon[0][0]).to be_within(1e-12).of(0.948979073166918)
      expect(polygon[0][1]).to be_within(1e-12).of(0.23097924535067715)

      expect(polygon[1][0]).to be_within(1e-12).of(0.85422)
      expect(polygon[1][1]).to be_within(1e-12).of(0.230072)

      expect(polygon[2][0]).to be_within(1e-12).of(0.8540899268330819)
      expect(polygon[2][1]).to be_within(1e-12).of(0.24365775464932288)

      expect(polygon[3][0]).to be_within(1e-12).of(0.948849)
      expect(polygon[3][1]).to be_within(1e-12).of(0.244565)

      # Confidence can be a FieldConfidence instance or a String depending on implementation.
      conf_value =
        if date_field.confidence.respond_to?(:to_s)
          date_field.confidence.to_s
        else
          date_field.confidence
        end
      expect(conf_value).to eq('Medium')

      # Optional strict check if equality supports comparing with FieldConfidence constants:
      if defined?(field_conf) && field_conf.respond_to?(:from_string)
        expect(conf_value).to eq(field_conf.from_string('Medium').to_s)
      end
    end
  end
end
