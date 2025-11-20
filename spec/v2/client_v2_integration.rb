# frozen_string_literal: true

describe 'Mindee::ClientV2 – integration tests (V2)', :integration, order: :defined do
  let(:api_key) { ENV.fetch('MINDEE_V2_API_KEY') }
  let(:model_id) { ENV.fetch('MINDEE_V2_FINDOC_MODEL_ID') }
  let(:blank_pdf_url) { ENV.fetch('MINDEE_V2_SE_TESTS_BLANK_PDF_URL') }

  let(:client) { Mindee::ClientV2.new(api_key: api_key) }
  context 'An input file' do
    it 'parses an empty multi-page PDF successfully' do
      src_path = File.join(FILE_TYPES_DIR, 'pdf', 'multipage_cut-2.pdf')
      input = Mindee::Input::Source::FileInputSource.new(File.open(src_path, 'rb'), 'multipage_cut-2.pdf')

      polling = Mindee::Input::PollingOptions.new(
        initial_delay_sec: 3.0,
        delay_sec: 1.5,
        max_retries: 80
      )

      inference_params = Mindee::Input::InferenceParameters.new(
        model_id,
        rag: false,
        raw_text: true,
        polygon: false,
        confidence: false,
        file_alias: 'ruby-integration-test',
        polling_options: polling
      )

      response = client.enqueue_and_get_inference(input, inference_params)

      expect(response).not_to be_nil
      expect(response.inference).not_to be_nil

      file = response.inference.file
      expect(file).not_to be_nil
      expect(file).to be_a(Mindee::Parsing::V2::InferenceFile)
      expect(file.name).to eq('multipage_cut-2.pdf')
      expect(file.page_count).to eq(2)

      model = response.inference.model
      expect(model).not_to be_nil
      expect(model).to be_a(Mindee::Parsing::V2::InferenceModel)
      expect(model.id).to eq(model_id)

      active_options = response.inference.active_options
      expect(active_options).not_to be_nil
      expect(active_options).to be_a(Mindee::Parsing::V2::InferenceActiveOptions)
      expect(active_options.raw_text).to eq(true)
      expect(active_options.polygon).to eq(false)
      expect(active_options.confidence).to eq(false)
      expect(active_options.rag).to eq(false)

      result = response.inference.result
      expect(result).not_to be_nil

      expect(result.raw_text).not_to be_nil
      expect(result.raw_text.pages.length).to eq(2)

      expect(result.fields).not_to be_nil
    end

    it 'parses a filled single-page image successfully' do
      src_path = File.join(V1_PRODUCT_DATA_DIR, 'financial_document', 'default_sample.jpg')
      input = Mindee::Input::Source::FileInputSource.new(File.open(src_path, 'rb'), 'default_sample.jpg')

      inference_params = Mindee::Input::InferenceParameters.new(
        model_id,
        raw_text: false,
        polygon: false,
        confidence: false,
        rag: false,
        file_alias: 'ruby-integration-test'
      )

      response = client.enqueue_and_get_inference(input, inference_params)
      expect(response).not_to be_nil

      file = response.inference.file
      expect(file).not_to be_nil
      expect(file).to be_a(Mindee::Parsing::V2::InferenceFile)
      expect(file.name).to eq('default_sample.jpg')
      expect(file.page_count).to eq(1)

      model = response.inference.model
      expect(model).not_to be_nil
      expect(model).to be_a(Mindee::Parsing::V2::InferenceModel)
      expect(model.id).to eq(model_id)

      active_options = response.inference.active_options
      expect(active_options).not_to be_nil
      expect(active_options).to be_a(Mindee::Parsing::V2::InferenceActiveOptions)
      expect(active_options.raw_text).to eq(false)
      expect(active_options.polygon).to eq(false)
      expect(active_options.confidence).to eq(false)
      expect(active_options.rag).to eq(false)

      result = response.inference.result
      expect(result).not_to be_nil

      expect(result.raw_text).to be_nil

      fields = result.fields
      expect(fields).not_to be_nil
      expect(fields['supplier_name']).not_to be_nil
      expect(fields['supplier_name'].value).to eq('John Smith')
    end
  end
  context 'An error' do
    it 'raises MindeeHTTPErrorV2 (422) on invalid model id' do
      src_path = File.join(FILE_TYPES_DIR, 'pdf', 'blank_1.pdf')
      input = Mindee::Input::Source::FileInputSource.new(File.open(src_path, 'rb'), 'blank_1.pdf')

      inference_params = Mindee::Input::InferenceParameters.new('INVALID_MODEL_ID')

      expect do
        client.enqueue_inference(input, inference_params)
      end.to raise_error(Mindee::Errors::MindeeHTTPErrorV2) { |e| expect(e.status).to eq(422) }
    end

    it 'raises MindeeHTTPErrorV2 (422) on invalid webhook id' do
      src_path = File.join(FILE_TYPES_DIR, 'pdf', 'blank_1.pdf')
      input = Mindee::Input::Source::FileInputSource.new(File.open(src_path, 'rb'), 'blank_1.pdf')

      params = Mindee::Input::InferenceParameters.new(
        model_id,
        webhook_ids: ['INVALID_WEBHOOK_ID']
      )

      expect do
        client.enqueue_inference(input, params)
      end.to raise_error(Mindee::Errors::MindeeHTTPErrorV2) { |e|
        expect(e.status).to eq(422)
        expect(e.code).to start_with('422-')
        expect(e.detail).to_not be_nil
        expect(e.title).to_not be_nil
        expect(e.errors).to be_an_instance_of(Array)
        expect(e.errors.count).to be_positive
      }
    end

    it 'raises MindeeHTTPErrorV2 (422) on non-existant webhook id' do
      src_path = File.join(FILE_TYPES_DIR, 'pdf', 'blank_1.pdf')
      input = Mindee::Input::Source::FileInputSource.new(File.open(src_path, 'rb'), 'blank_1.pdf')

      inference_params = Mindee::Input::InferenceParameters.new(
        model_id,
        webhook_ids: ['fc405e37-4ba4-4d03-aeba-533a8d1f0f21', 'fc405e37-4ba4-4d03-aeba-533a8d1f0f21']
      )

      expect do
        client.enqueue_inference(input, inference_params)
      end.to raise_error(Mindee::Errors::MindeeHTTPErrorV2) { |e|
        expect(e.status).to eq(422)
        expect(e.code).to start_with('422-')
        expect(e.detail).to_not be_nil
        expect(e.title).to_not be_nil
        expect(e.errors).to be_an_instance_of(Array)
        expect(e.errors.count).to be_positive
        expect(e.errors[0]).to be_an_instance_of(Mindee::Parsing::V2::ErrorItem)
      }
    end

    it 'raises MindeeHTTPErrorV2 on invalid job id' do
      expect do
        client.get_inference('INVALID_JOB_ID')
      end.to raise_error(Mindee::Errors::MindeeHTTPErrorV2) { |e|
        expect(e.status).to eq(422)
        expect(e.code).to start_with('422-')
        expect(e.detail).to_not be_nil
        expect(e.title).to_not be_nil
        expect(e.errors).to be_an_instance_of(Array)
        expect(e.errors.count).to be_positive
      }
    end

    it 'raises on invalid model ID' do
      expect do
        src_path = File.join(V1_PRODUCT_DATA_DIR, 'financial_document', 'default_sample.jpg')
        input = Mindee::Input::Source::FileInputSource.new(
          File.open(src_path, 'rb'),
          'default_sample.jpg'
        )

        inference_params = Mindee::Input::InferenceParameters.new(
          'fc405e37-4ba4-4d03-aeba-533a8d1f0f21',
          raw_text: false,
          polygon: false,
          confidence: false,
          rag: false,
          file_alias: 'ruby-integration-test'
        )
        client.enqueue_and_get_inference(input, inference_params)
      end.to raise_error(Mindee::Errors::MindeeHTTPErrorV2) { |e|
        expect(e.status).to eq(404)
        expect(e.code).to start_with('404-')
        expect(e.detail).to_not be_nil
        expect(e.title).to_not be_nil
        expect(e.errors).to be_an_instance_of(Array)
      }
    end
  end

  context 'A remote input source' do
    it 'parses an URL input source without errors' do
      url_input = Mindee::Input::Source::URLInputSource.new(blank_pdf_url)

      inference_params = Mindee::Input::InferenceParameters.new(model_id)

      response = client.enqueue_and_get_inference(url_input, inference_params)

      expect(response).not_to be_nil
      expect(response.inference).not_to be_nil
    end
  end
end
