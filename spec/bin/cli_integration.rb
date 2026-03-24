# frozen_string_literal: true

require 'open3'
require 'rbconfig'
require_relative '../data'

describe 'Mindee CLI V2', :integration, :v2, order: :defined do
  let(:findoc_model_id) { ENV.fetch('MINDEE_V2_SE_TESTS_FINDOC_MODEL_ID') }
  let(:classification_model_id) { ENV.fetch('MINDEE_V2_SE_TESTS_CLASSIFICATION_MODEL_ID') }
  let(:crop_model_id) { ENV.fetch('MINDEE_V2_SE_TESTS_CROP_MODEL_ID') }
  let(:ocr_model_id) { ENV.fetch('MINDEE_V2_SE_TESTS_OCR_MODEL_ID') }
  let(:split_model_id) { ENV.fetch('MINDEE_V2_SE_TESTS_SPLIT_MODEL_ID') }
  let(:blank_pdf_url) { ENV.fetch('MINDEE_V2_SE_TESTS_BLANK_PDF_URL') }
  let(:test_file) { File.join(FILE_TYPES_DIR, 'pdf', 'blank_1.pdf') }
  let(:cli_path) { File.expand_path('../../bin/mindee.rb', __dir__) }

  def run_cli(*args)
    Open3.capture3(RbConfig.ruby, cli_path, *args)
  end

  context 'search-models command' do
    ['classification', 'crop', 'extraction', 'ocr', 'split'].each do |model_type|
      it "returns model list for type #{model_type}" do
        stdout, stderr, status = run_cli('v2', 'search-models', '-t', model_type)
        expect(status.success?).to eq(true), stderr
        expect(stdout.strip).not_to be_empty
      end
    end

    it 'returns no models for non-existent name' do
      stdout, stderr, status = run_cli('v2', 'search-models', '-n', 'supercalifragilisticexpialidocious')
      expect(status.success?).to eq(true), stderr
      expect(['D, [2026-03-24T13:35:16.393819 #3543] DEBUG -- : API key set from environment',
              '']).to include(stdout.strip)
    end

    it 'returns models for name filter' do
      stdout, stderr, status = run_cli('v2', 'search-models', '-n', 'findoc')
      expect(status.success?).to eq(true), stderr
      expect(stdout.strip).not_to be_empty
    end

    it 'returns models for name and model_type filters' do
      stdout, stderr, status = run_cli('v2', 'search-models', '-n', 'findoc', '-t', 'extraction')
      expect(status.success?).to eq(true), stderr
      expect(stdout.strip).not_to be_empty
    end

    it 'returns HTTP 422 on invalid model type' do
      stdout, stderr, status = run_cli('v2', 'search-models', '-t', 'invalid')
      expect(status.success?).to eq(false)
      expect("#{stdout}\n#{stderr}").to include('HTTP 422')
    end
  end

  context 'product commands' do
    it 'runs extraction from an URL source' do
      stdout, stderr, status = run_cli('v2', 'extraction', '-m', findoc_model_id, blank_pdf_url)
      expect(status.success?).to eq(true), stderr
      expect(stdout.strip).not_to be_empty
    end

    {
      'classification' => -> { classification_model_id },
      'crop' => -> { crop_model_id },
      'ocr' => -> { ocr_model_id },
      'split' => -> { split_model_id },
    }.each do |command, model_id_proc|
      it "runs #{command} with default args" do
        stdout, stderr, status = run_cli('v2', command, '-m', instance_exec(&model_id_proc), test_file)
        expect(status.success?).to eq(true), stderr
        expect(stdout.strip).not_to be_empty
      end
    end
  end

  context 'extraction options' do
    [
      ['-a', 'toto'],
      ['-r'],
      ['-c'],
      ['-p'],
      ['-t', 'toto'],
    ].each do |option_args|
      it "runs extraction with #{option_args.join(' ')}" do
        stdout, stderr, status = run_cli('v2', 'extraction', '-m', findoc_model_id, test_file, *option_args)
        expect(status.success?).to eq(true), stderr
        expect(stdout.strip).not_to be_empty
      end
    end
  end
end
