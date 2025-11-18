# frozen_string_literal: true

require 'mindee'

RSpec.describe 'inference' do
  let(:findoc_path) { File.join(V2_DATA_DIR, 'products', 'financial_document') }
  let(:inference_path) { File.join(V2_DATA_DIR, 'inference') }
  let(:deep_nested_field_path) { File.join(inference_path, 'deep_nested_fields.json') }
  let(:standard_field_path) { File.join(inference_path, 'standard_field_types.json') }
  let(:standard_field_rst_path) { File.join(inference_path, 'standard_field_types.rst') }
  let(:location_field_path) { File.join(findoc_path, 'complete_with_coordinates.json') }
  let(:raw_text_json_path) { File.join(inference_path, 'raw_texts.json') }
  let(:raw_text_str_path) { File.join(inference_path, 'raw_texts.txt') }
  let(:blank_path) { File.join(findoc_path, 'blank.json') }
  let(:complete_path) { File.join(findoc_path, 'complete.json') }
  let(:rag_matched_path) { File.join(inference_path, 'rag_matched.json') }
  let(:rag_not_matched_path) { File.join(inference_path, 'rag_not_matched.json') }

  def load_v2_inference(resource_path)
    local_response = Mindee::Input::LocalResponse.new(resource_path)
    local_response.deserialize_response(Mindee::Parsing::V2::InferenceResponse)
  end

  simple_field = Mindee::Parsing::V2::Field::SimpleField
  object_field = Mindee::Parsing::V2::Field::ObjectField
  list_field = Mindee::Parsing::V2::Field::ListField
  field_confidence = Mindee::Parsing::V2::Field::FieldConfidence

  describe 'simple' do
    it 'loads a blank inference with valid properties' do
      response = load_v2_inference(blank_path)

      fields = response.inference.result.fields
      expect(fields).not_to be_empty
      expect(fields).to be_a(Mindee::Parsing::V2::Field::InferenceFields)
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
      inference = response.inference

      expect(inference).not_to be_nil
      expect(inference.id).to eq('12345678-1234-1234-1234-123456789abc')

      model = inference.model
      expect(model).not_to be_nil
      expect(model.id).to eq('12345678-1234-1234-1234-123456789abc')

      file = inference.file
      expect(file).not_to be_nil
      expect(file.name).to eq('complete.jpg')
      expect(file.file_alias).to be_nil
      expect(file.page_count).to eq(1)
      expect(file.mime_type).to eq('image/jpeg')

      active_options = inference.active_options
      expect(active_options).not_to be_nil
      expect(active_options.raw_text).to eq(false)
      expect(active_options.polygon).to eq(false)
      expect(active_options.confidence).to eq(false)
      expect(active_options.rag).to eq(false)

      fields = inference.result.fields
      expect(fields).not_to be_empty
      expect(fields.size).to eq(21)

      date_field = fields.get_simple_field('date')
      expect(date_field).to be_a(simple_field)
      expect(date_field.value).to eq('2019-11-02')

      expect(fields).to have_key('taxes')
      taxes = fields.get_list_field('taxes')
      expect(taxes).to be_a(list_field)

      expect(taxes.items.length).to eq(1)
      expect(taxes.to_s).to be_a(String)
      expect(taxes.to_s).to_not be_empty

      first_tax_item = taxes.items.first
      expect(first_tax_item).to be_a(object_field)

      tax_item_obj = first_tax_item
      expect(tax_item_obj.fields.size).to eq(3)

      expect(fields).to have_key('line_items')
      line_items = fields.get_list_field('line_items')
      expect(line_items).not_to be_nil
      expect(line_items).to be_a(list_field)
      first_line_item = line_items.object_items[0]
      expect(first_line_item).to be_a(object_field)
      expect(first_line_item.get_simple_field('quantity').value).to eq(1.0)

      base_field = tax_item_obj.fields.get_simple_field('base')
      expect(base_field).to be_a(simple_field)
      expect(base_field.value).to eq(31.5)

      expect(fields).to have_key('supplier_address')
      supplier_address = fields.get_object_field('supplier_address')
      expect(supplier_address).to be_a(object_field)
      expect(supplier_address.to_s).to be_a(String)
      expect(supplier_address.to_s).to_not be_empty

      country_field = supplier_address.fields.get_simple_field('country')
      expect(country_field).to be_a(simple_field)
      expect(country_field.value).to eq('USA')
      expect(country_field.to_s).to eq('USA')

      customer_addr = fields.get_object_field('customer_address')
      expect(customer_addr).to be_a(object_field)
      city_field = customer_addr.fields.get_simple_field('city')
      expect(city_field).to be_a(simple_field)
      expect(city_field.value).to eq('New York')

      expect(inference.result.raw_text).to be_nil
    end
  end

  describe 'nested' do
    it 'loads a deep nested object' do
      response = load_v2_inference(deep_nested_field_path)
      fields = response.inference.result.fields

      expect(fields['field_simple']).to be_a(simple_field)
      expect(fields['field_object']).to be_a(object_field)

      field_object = fields.get_object_field('field_object')
      lvl1 = field_object.fields

      expect(lvl1['sub_object_list']).to be_a(list_field)
      expect(lvl1['sub_object_object']).to be_a(object_field)

      sub_object_object = lvl1.get_object_field('sub_object_object')
      lvl2 = sub_object_object.fields

      expect(lvl2['sub_object_object_sub_object_list']).to be_a(list_field)

      nested_list = lvl2.get_list_field('sub_object_object_sub_object_list')
      expect(nested_list.items).not_to be_empty
      expect(nested_list.items.first).to be_a(object_field)

      first_item_obj = nested_list.items.first
      deep_simple = first_item_obj.fields['sub_object_object_sub_object_list_simple']

      expect(deep_simple).to be_a(simple_field)
      expect(deep_simple.value).to eq('value_9')
    end
  end

  describe 'standard field types' do
    def load_standard_fields
      response = load_v2_inference(standard_field_path)

      active_options = response.inference.active_options
      expect(active_options).not_to be_nil
      expect(active_options.raw_text).to eq(true)

      fields = response.inference.result.fields
      expect(fields).to be_a(Mindee::Parsing::V2::Field::InferenceFields)

      fields
    end

    it 'recognizes simple fields' do
      fields = load_standard_fields

      # low-level access
      expect(fields['field_simple_string']).to be_a(simple_field)
      expect(fields.get('field_simple_string')).to be_a(simple_field)

      field_simple_string = fields.get_simple_field('field_simple_string')
      expect(field_simple_string).to be_a(simple_field)
      expect(field_simple_string.value).to eq('field_simple_string-value')
      expect(field_simple_string.confidence).to eq(field_confidence::CERTAIN)
      expect(field_simple_string.to_s).to eq('field_simple_string-value')

      field_simple_int = fields.get_simple_field('field_simple_int')
      expect(field_simple_int).to be_a(simple_field)
      expect(field_simple_int.value).to be_a(Float)

      field_simple_float = fields.get_simple_field('field_simple_float')
      expect(field_simple_float).to be_a(simple_field)
      expect(field_simple_float.value).to be_a(Float)

      field_simple_bool = fields.get_simple_field('field_simple_bool')
      expect(field_simple_bool).to be_a(simple_field)
      expect(field_simple_bool.value).to eq(true)
      expect(field_simple_bool.to_s).to eq('True')

      field_simple_null = fields.get_simple_field('field_simple_null')
      expect(field_simple_null).to be_a(simple_field)
      expect(field_simple_null.value).to be_nil
      expect(field_simple_null.to_s).to eq('')
    end

    it 'recognizes simple list fields' do
      fields = load_standard_fields

      # low-level access
      expect(fields['field_simple_list']).to be_a(list_field)
      expect(fields.get('field_simple_list')).to be_a(list_field)

      field_simple_list = fields.get_list_field('field_simple_list')
      expect(field_simple_list).to be_a(list_field)

      expect(field_simple_list.items[0]).to be_a(simple_field)
      expect(field_simple_list.simple_items[0]).to be_a(simple_field)
      field_simple_list.simple_items.each do |entry|
        expect(entry).to be_a(simple_field)
        expect(entry.value).not_to be_nil
      end
    end

    it 'recognizes object fields' do
      fields = load_standard_fields

      # low-level access
      expect(fields['field_object']).to be_a(object_field)
      expect(fields.get('field_object')).to be_a(object_field)

      field_object = fields.get_object_field('field_object')
      expect(field_object).to be_a(object_field)
      expect(field_object.get_simple_field('subfield_1')).to be_a(simple_field)
      field_object.fields.each_value do |entry|
        expect(entry).to be_a(simple_field)
        expect(entry.value).not_to be_nil
      end
    end

    it 'recognizes object list fields' do
      fields = load_standard_fields

      # low-level access
      expect(fields['field_object_list']).to be_a(list_field)
      expect(fields.get('field_object_list')).to be_a(list_field)

      field_object_list = fields.get_list_field('field_object_list')
      expect(field_object_list).to be_a(list_field)

      expect(field_object_list.items[0]).to be_a(object_field)
      expect(field_object_list.object_items[0]).to be_a(object_field)
      field_object_list.object_items.each do |entry|
        expect(entry).to be_a(object_field)
        expect(entry.fields).not_to be_nil
      end
    end
  end

  describe 'raw_text' do
    it 'exposes raw texts' do
      response = load_v2_inference(raw_text_json_path)

      active_options = response.inference.active_options
      expect(active_options).not_to be_nil
      expect(active_options.raw_text).to eq(true)

      raw_text = response.inference.result.raw_text
      expect(raw_text).not_to be_nil
      expect(raw_text).to be_a(Mindee::Parsing::V2::RawText)

      expect(raw_text.to_s).to eq(File.read(raw_text_str_path, encoding: 'UTF-8'))

      expect(raw_text.pages.length).to eq(2)
      first = raw_text.pages.first
      expect(first).to be_a(Mindee::Parsing::V2::RawTextPage)
      expect(first.content).to eq('This is the raw text of the first page...')

      raw_text.pages.each do |page|
        expect(page.content).to be_a(String)
      end
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

      date_field = response.inference.result.fields.get_simple_field('date')
      expect(date_field).to be_a(simple_field)
      expect(date_field.locations).to be_an(Array)
      expect(date_field.locations[0]).not_to be_nil
      expect(date_field.locations[0].page).to eq(0)

      polygon = date_field.locations[0].polygon
      expect(polygon[0]).to be_a(Mindee::Geometry::Point)

      expect(polygon[0].x).to eq(0.948979073166918)
      expect(polygon[0].y).to eq(0.23097924535067715)

      expect(polygon[1][0]).to eq(0.85422)
      expect(polygon[1][1]).to eq(0.230072)

      expect(polygon[2][0]).to eq(0.8540899268330819)
      expect(polygon[2][1]).to eq(0.24365775464932288)

      expect(polygon[3][0]).to eq(0.948849)
      expect(polygon[3][1]).to eq(0.244565)

      centroid = polygon.centroid
      expect(centroid.x).to eq(0.9015345)
      expect(centroid.y).to eq(0.23731850000000002)

      confidence = date_field.confidence
      expect(confidence).to be_a(field_confidence)
      # equality
      expect(confidence).to eq(field_confidence::MEDIUM)
      expect(confidence).to eq('Medium')
      expect(confidence).to eq(2)
      # less than or equal
      expect(confidence).to be_lteql(field_confidence::HIGH)
      expect(confidence).to be_lteql('High')
      expect(confidence).to be_lteql(3)
      # greater than or equal
      expect(confidence).to be_gteql(field_confidence::LOW)
      expect(confidence).to be_gteql('Low')
      expect(confidence).to be_gteql(1)
    end
  end
  describe 'RAG Metadata' do
    it 'when matched' do
      response = load_v2_inference(rag_matched_path)
      expect(response.inference).not_to be_nil
      expect(response.inference.result.rag.retrieved_document_id).to eq('12345abc-1234-1234-1234-123456789abc')
    end

    it 'when not matched' do
      response = load_v2_inference(rag_not_matched_path)
      expect(response.inference).not_to be_nil
      expect(response.inference.result.rag.retrieved_document_id).to be_nil
    end
  end
end
