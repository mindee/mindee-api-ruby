# frozen_string_literal: true

require 'mindee'
require 'mindee/v2/product'

describe Mindee::V2::Product::Extraction::RagDocuments, :integration, :v2 do
  let(:extraction_model_id) do
    model_id = ENV.fetch('MINDEE_V2_SE_TESTS_FINDOC_MODEL_ID', '')
    raise 'Missing MINDEE_V2_SE_TESTS_FINDOC_MODEL_ID environment variable.' if model_id.empty?

    model_id
  end

  let(:v2_client) do
    Mindee::V2::Client.new
  end

  it 'should perform the entire lifecycle of a RAG document' do
    input_source = Mindee::Input::Source::PathInputSource.new(
      File.join(V2_PRODUCT_DATA_DIR, 'extraction', 'financial_document', 'default_sample.jpg')
    )

    post_response = v2_client.upload_and_get_rag_document(
      Mindee::V2::Product::Extraction::Extraction,
      input_source,
      { model_id: extraction_model_id }
    )
    expect(post_response).not_to be_nil

    post_annotation = post_response.annotation
    expect(post_annotation).not_to be_nil
    expect(post_annotation.fields).not_to be_nil

    document_id = post_response.id
    expect(document_id).not_to be_nil
    expect(document_id).not_to be_empty

    expect(post_response.status).to eq('Draft')

    post_annotation.fields.get_simple_field('supplier_name').selected = true
    post_annotation.fields.get_simple_field('supplier_name').guidelines = 'I am the walrus!'
    post_annotation.fields.get_simple_field('invoice_number').selected = true
    post_annotation.fields.get_simple_field('invoice_number').guidelines = 'koo koo katchoo!'

    patch_annotation_response = v2_client.update_rag_annotation(
      Mindee::V2::Product::Extraction::Extraction,
      { document_id: document_id, annotation: post_annotation }
    )
    expect(patch_annotation_response).not_to be_nil
    patch_annotation = patch_annotation_response.annotation
    expect(patch_annotation).not_to be_nil
    expect(patch_annotation.fields.get_simple_field('supplier_name').guidelines).to eq('I am the walrus!')
    expect(patch_annotation.fields.get_simple_field('supplier_name').selected).to be(true)
    expect(patch_annotation.fields.get_simple_field('invoice_number').guidelines).to eq('koo koo katchoo!')
    expect(patch_annotation.fields.get_simple_field('invoice_number').selected).to be(true)

    get_response = v2_client.get_ready_rag_document(
      Mindee::V2::Product::Extraction::Extraction,
      document_id
    )
    expect(get_response).not_to be_nil
    get_annotation = get_response.annotation
    expect(get_annotation).not_to be_nil
    expect(get_response.status).to eq('Draft')
    expect(get_annotation.fields.get_simple_field('supplier_name').guidelines).to eq('I am the walrus!')
    expect(get_annotation.fields.get_simple_field('supplier_name').selected).to be(true)
    expect(get_annotation.fields.get_simple_field('invoice_number').guidelines).to eq('koo koo katchoo!')
    expect(get_annotation.fields.get_simple_field('invoice_number').selected).to be(true)

    patch_status_params = Mindee::V2::Product::Extraction::RagDocuments::Params::RagDocumentAnnotationParameters.new(
      document_id,
      status: 'Active'
    )
    patch_status_response = v2_client.update_and_get_rag_annotation(
      Mindee::V2::Product::Extraction::Extraction,
      patch_status_params,
      { initial_delay_sec: 1.2 }
    )
    expect(patch_status_response).not_to be_nil
    expect(patch_status_response.status).to eq('Active')

    delete_response = v2_client.delete_rag_document(
      Mindee::V2::Product::Extraction::Extraction,
      document_id
    )
    expect(delete_response).to be(true)

    expect do
      v2_client.get_rag_document(
        Mindee::V2::Product::Extraction::Extraction,
        document_id
      )
    end.to raise_error(Mindee::Error::MindeeHTTPErrorV2)
  end
end
