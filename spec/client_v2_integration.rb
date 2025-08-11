# frozen_string_literal: true

RSpec.describe 'Mindee::ClientV2 – integration tests (V2)', :integration, order: :defined do
  let(:api_key) { ENV.fetch('MINDEE_V2_API_KEY') }
  let(:model_id) { ENV.fetch('MINDEE_V2_FINDOC_MODEL_ID') }
  let(:blank_pdf_url) { ENV.fetch('MINDEE_V2_SE_TESTS_BLANK_PDF_URL') }

  let(:client) { Mindee::ClientV2.new(api_key: api_key) }

  it 'parses an empty multi-page PDF successfully' do
    src_path = File.join(__dir__ || './', 'data', 'file_types', 'pdf', 'multipage_cut-2.pdf')
    input = Mindee::Input::Source::FileInputSource.new(File.open(src_path, 'rb'), 'multipage_cut-2.pdf')

    polling = Mindee::Input::PollingOptions.new(
      initial_delay_sec: 3.0,
      delay_sec: 1.5,
      max_retries: 80
    )

    params = Mindee::Input::InferenceParameters.new(params: {
                                                      model_id: model_id,
                                                      rag: false,
                                                      alias: 'ruby-integration-test',
                                                      polling_options: polling,
                                                    })

    resp = client.enqueue_and_get_inference(input, params)

    expect(resp).not_to be_nil
    expect(resp.inference).not_to be_nil

    expect(resp.inference.file).not_to be_nil
    expect(resp.inference.file.name).to eq('multipage_cut-2.pdf')

    expect(resp.inference.model).not_to be_nil
    expect(resp.inference.model.id).to eq(model_id)

    expect(resp.inference.result).not_to be_nil
    expect(resp.inference.result.options).to be_nil
  end

  it 'parses a filled single-page image successfully' do
    src_path = File.join(__dir__ || './', 'data', 'products', 'financial_document', 'default_sample.jpg')
    input = Mindee::Input::Source::FileInputSource.new(File.open(src_path, 'rb'), 'default_sample.jpg')

    params = Mindee::Input::InferenceParameters.new(params: {
                                                      model_id: model_id,
                                                      rag: false,
                                                      alias: 'ruby-integration-test',
                                                    })

    resp = client.enqueue_and_get_inference(input, params)

    expect(resp).not_to be_nil
    expect(resp.inference.file.name).to eq('default_sample.jpg')
    expect(resp.inference.model.id).to eq(model_id)

    fields = resp.inference.result.fields
    expect(fields).not_to be_nil
    expect(fields['supplier_name']).not_to be_nil
    expect(fields['supplier_name'].value).to eq('John Smith')
  end

  it 'raises MindeeHTTPErrorV2 (422) on invalid model id' do
    src_path = File.join(__dir__ || './', 'data', 'file_types', 'pdf', 'blank_1.pdf')
    input = Mindee::Input::Source::FileInputSource.new(File.open(src_path, 'rb'), 'blank_1.pdf')

    params = Mindee::Input::InferenceParameters.new(params: { model_id: 'INVALID_MODEL_ID' })

    expect do
      client.enqueue_inference(input, params)
    end.to raise_error(Mindee::Errors::MindeeHTTPErrorV2) { |e| expect(e.status).to eq(422) }
  end

  it 'raises MindeeHTTPErrorV2 (422) on invalid webhook id' do
    src_path = File.join(__dir__ || './', 'data', 'file_types', 'pdf', 'blank_1.pdf')
    input = Mindee::Input::Source::FileInputSource.new(File.open(src_path, 'rb'), 'blank_1.pdf')

    params = Mindee::Input::InferenceParameters.new(params: {
                                                      model_id: model_id,
                                                      webhook_ids: ['INVALID_WEBHOOK_ID'],
                                                    })

    expect do
      client.enqueue_inference(input, params)
    end.to raise_error(Mindee::Errors::MindeeHTTPErrorV2) { |e| expect(e.status).to eq(422) }
  end

  it 'raises MindeeHTTPErrorV2 on invalid job id' do
    expect do
      client.get_inference('INVALID_JOB_ID')
    end.to raise_error(Mindee::Errors::MindeeHTTPErrorV2) { |e| expect(e.status).to eq(422) }
  end

  it 'parses an URL input source without errors' do
    url_input = Mindee::Input::Source::URLInputSource.new(blank_pdf_url)

    params = Mindee::Input::InferenceParameters.new(params: { model_id: model_id })

    resp = client.enqueue_and_get_inference(url_input, params)

    expect(resp).not_to be_nil
    expect(resp.inference).not_to be_nil
  end
end
