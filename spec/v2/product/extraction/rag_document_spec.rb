# frozen_string_literal: true

require 'json'
require_relative '../../../data'

require 'mindee/v2/product/extraction/rag_documents'

describe Mindee::V2::Product::Extraction::RagDocuments do
  let(:expected_annotation) do
    raw_json = File.read(File.join(V2_PRODUCT_DATA_DIR, 'extraction', 'rag_documents', 'test_annotation.json'))
    JSON.parse(raw_json)
  end

  def get_response(relative_path)
    file_path = File.join(V2_PRODUCT_DATA_DIR, relative_path)
    dict = JSON.parse(File.read(file_path))
    Mindee::V2::Product::Extraction::RagDocuments::ExtractionRagAnnotationResponse.new(dict)
  end

  it 'should init POST parameters' do
    parameters = Mindee::V2::Product::Extraction::RagDocuments::Params::RagDocumentUploadParameters.new(
      'invalid-model-id'
    )
    req_params = parameters.request_parameters

    expect(req_params['model_id']).to eq('invalid-model-id')
  end

  it 'should init PATCH parameters from an annotation hash' do
    annotation = {
      'fields' => {
        'simple' => { 'value' => true },
        'list' => { 'items' => [] },
        'object' => { 'fields' => {} },
      },
    }
    parameters = Mindee::V2::Product::Extraction::RagDocuments::Params::RagDocumentAnnotationParameters.new(
      'invalid-document-id',
      status: 'Active',
      annotation: annotation
    )
    expect(parameters.document_id).to eq('invalid-document-id')
    req_params = parameters.request_parameters

    expect(req_params['status']).to eq('Active')
    expect(req_params['annotation']).to eq(expected_annotation)
  end

  it 'should init PATCH parameters from an annotation instance' do
    annotation = Mindee::V2::Product::Extraction::RagDocuments::RagAnnotation.new(
      'fields' => {
        'simple' => { 'value' => true },
        'list' => { 'items' => [] },
        'object' => { 'fields' => {} },
      }
    )
    parameters = Mindee::V2::Product::Extraction::RagDocuments::Params::RagDocumentAnnotationParameters.new(
      'invalid-document-id',
      status: 'Active',
      annotation: annotation
    )
    expect(parameters.document_id).to eq('invalid-document-id')

    req_params = parameters.request_parameters
    expect(req_params['status']).to eq('Active')
    expect(req_params['annotation']).to eq(expected_annotation)
  end

  it 'should init PATCH parameters from an annotation string' do
    parameters = Mindee::V2::Product::Extraction::RagDocuments::Params::RagDocumentAnnotationParameters.new(
      'invalid-document-id',
      status: 'Active',
      annotation: '{"fields": {"simple":{"value": true}, "list":{"items": []}, "object":{"fields": {}}}}'
    )
    expect(parameters.document_id).to eq('invalid-document-id')

    req_params = parameters.request_parameters
    expect(req_params['status']).to eq('Active')
    expect(req_params['annotation']).to eq(expected_annotation)
  end

  it 'should load a POST response from a JSON string' do
    response = get_response('extraction/rag_documents/post_response.json')

    expect(response).not_to be_nil
    expect(response.id).to eq('cc831599-c545-48b7-aa27-6d7ccd5b8d32')
    expect(response.status).to eq('Processing')
    expect(response.annotation).to be_nil
  end

  it 'should load a GET response from a JSON string' do
    file_path = 'extraction/rag_documents/get_response_draft.json'
    response = get_response(file_path)

    expect(response).not_to be_nil
    expect(response.id).to eq('cc831599-c545-48b7-aa27-6d7ccd5b8d32')
    expect(response.status).to eq('Draft')
    expect(response.annotation).not_to be_nil

    response_dict = JSON.parse(File.read(File.join(V2_PRODUCT_DATA_DIR, file_path)))
    actual = response.annotation.to_h
    expected = response_dict['annotation']
    expect(actual.keys).to eq(expected.keys)

    fields = response.annotation.fields
    expect(fields).not_to be_nil

    # null simple field
    tip_field = fields.get_simple_field('tip')
    expect(tip_field).not_to be_nil
    expect(tip_field.selected).to be(false)
    expect(tip_field.guidelines).to be_nil
    expect(tip_field.value).to be_nil

    # filled simple field
    date_field = fields.get_simple_field('date')
    expect(date_field).not_to be_nil
    expect(date_field.selected).to be(false)
    expect(date_field.guidelines).to be_nil
    expect(date_field.value).to eq('2019-11-02')

    # filled object field
    locale_field = fields.get_object_field('locale')
    expect(locale_field).not_to be_nil
    expect(locale_field.selected).to be(false)
    expect(locale_field.guidelines).to be_nil
    expect(locale_field.fields).not_to be_nil
    expect(locale_field.fields.size).to eq(3)
    expect(locale_field.get_simple_field('country').value).to eq('US')
    expect(locale_field.get_simple_field('currency').value).to eq('USD')
    expect(locale_field.get_simple_field('language').value).to be_nil

    # list of simple fields
    reference_numbers_field = fields.get_list_field('reference_numbers')
    expect(reference_numbers_field).not_to be_nil
    expect(reference_numbers_field.selected).to be(false)
    expect(reference_numbers_field.guidelines).to be_nil
    expect(reference_numbers_field.simple_items).not_to be_nil
    expect(reference_numbers_field.simple_items.length).to eq(1)
    expect(reference_numbers_field.simple_items[0].value).to eq('2412/2019')

    # list of object fields
    line_items_field = fields.get_list_field('line_items')
    expect(line_items_field).not_to be_nil
    expect(line_items_field.selected).to be(false)
    expect(line_items_field.guidelines).to be_nil
    expect(line_items_field.object_items).not_to be_nil
    expect(line_items_field.object_items.length).to eq(3)

    line_item0 = line_items_field.object_items[0]
    expect(line_item0.fields).not_to be_nil
    expect(line_item0.fields.size).to eq(8)
    expect(line_item0.get_simple_field('description').value).to eq('Front and rear brake cables')
    expect(line_item0.get_simple_field('quantity').value).to eq(1)
    expect(line_item0.get_simple_field('unit_price').value).to eq(100)
    expect(line_item0.get_simple_field('total_price').value).to eq(100)
    expect(line_item0.get_simple_field('tax_rate').value).to be_nil
    expect(line_item0.get_simple_field('tax_amount').value).to be_nil
    expect(line_item0.get_simple_field('product_code').value).to be_nil
    expect(line_item0.get_simple_field('unit_measure').value).to be_nil

    line_item1 = line_items_field.object_items[1]
    expect(line_item1.fields).not_to be_nil
    expect(line_item1.fields.size).to eq(8)
    expect(line_item1.get_simple_field('description').value).to eq('New set of pedal arms')
    expect(line_item1.get_simple_field('quantity').value).to eq(2)
    expect(line_item1.get_simple_field('unit_price').value).to eq(25)
    expect(line_item1.get_simple_field('total_price').value).to eq(50)
    expect(line_item1.get_simple_field('tax_rate').value).to be_nil
    expect(line_item1.get_simple_field('tax_amount').value).to be_nil
    expect(line_item1.get_simple_field('product_code').value).to be_nil
    expect(line_item1.get_simple_field('unit_measure').value).to be_nil

    line_item2 = line_items_field.object_items[2]
    expect(line_item2.fields).not_to be_nil
    expect(line_item2.fields.size).to eq(8)
    expect(line_item2.get_simple_field('description').value).to eq('Labor 3hrs')
    expect(line_item2.get_simple_field('quantity').value).to eq(3)
    expect(line_item2.get_simple_field('unit_price').value).to eq(15)
    expect(line_item2.get_simple_field('total_price').value).to eq(45)
    expect(line_item2.get_simple_field('tax_rate').value).to be_nil
    expect(line_item2.get_simple_field('tax_amount').value).to be_nil
    expect(line_item2.get_simple_field('product_code').value).to be_nil
    expect(line_item2.get_simple_field('unit_measure').value).to be_nil
  end
end
