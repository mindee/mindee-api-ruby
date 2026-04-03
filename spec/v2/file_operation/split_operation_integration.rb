# frozen_string_literal: true

require 'mindee'
require 'mindee/v2/file_operation'
require 'mindee/v2/product'
require 'fileutils'

describe Mindee::V2::Product::Split::Split, :integration, :v2, :all_deps do
  let(:split_sample) do
    File.join(V2_PRODUCT_DATA_DIR, 'split', 'default_sample.pdf')
  end

  let(:invoice_splitter_5p_path) do
    File.join(V2_PRODUCT_DATA_DIR, 'split', 'invoice_5p.pdf')
  end

  let(:v2_client) do
    Mindee::V2::Client.new
  end

  let(:split_model_id) do
    ENV.fetch('MINDEE_V2_SE_TESTS_SPLIT_MODEL_ID')
  end

  let(:findoc_model_id) do
    ENV.fetch('MINDEE_V2_SE_TESTS_FINDOC_MODEL_ID')
  end

  after(:all) do
    FileUtils.rm_f("#{OUTPUT_DIR}/split_001.pdf")
    FileUtils.rm_f("#{OUTPUT_DIR}/split_002.pdf")
  end

  # Validates the parsed financial document response properties.
  #
  # @param findoc_response [Mindee::V2::InferenceResponse] The inference response to check.
  def check_findoc_return(findoc_response)
    expect(findoc_response.inference.model.id.length).to be > 0
    expect(findoc_response.inference.result.fields['total_amount'].value).to be > 0
  end

  it 'extracts splits from pdf correctly' do
    split_input = Mindee::Input::Source::PathInputSource.new(split_sample)

    split_params = { model_id: split_model_id, close_file: false }

    response = v2_client.enqueue_and_get_result(
      Mindee::V2::Product::Split::Split,
      split_input,
      split_params
    )

    expect(response.inference.file.page_count).to eq(2)

    extracted_pdfs = response.extract_from_file(split_input)

    expect(extracted_pdfs.size).to eq(2)
    expect(extracted_pdfs[0].filename).to eq('default_sample_001-001.pdf')
    expect(extracted_pdfs[1].filename).to eq('default_sample_002-002.pdf')

    findoc_params = { model_id: findoc_model_id, close_file: false }

    invoice0 = v2_client.enqueue_and_get_result(
      Mindee::V2::Product::Extraction::Extraction,
      extracted_pdfs[0].as_input_source,
      findoc_params
    )

    check_findoc_return(invoice0)

    extracted_pdfs.save_all_to_disk(OUTPUT_DIR)

    extracted_pdfs.each_with_index do |pdf, i|
      local_input = Mindee::Input::Source::PathInputSource.new(File.join(OUTPUT_DIR, format('split_%03d.pdf', i + 1)))
      begin
        expect(local_input.page_count).to eq(pdf.page_count)
      ensure
        local_input.close if local_input.respond_to?(:close)
      end
    end
  ensure
    split_input.close if split_input.respond_to?(:close)
  end
end
