# frozen_string_literal: true

require 'mindee'

describe Mindee::Input::Source::PathInputSource do
  let(:input_file) { "#{V1_DATA_DIR}/products/invoices/default_sample.jpg" }
  let(:output_dir) { "#{ROOT_DATA_DIR}/output/" }

  describe '#write_to_file' do
    let(:local_input_source) { described_class.new(input_file) }

    context 'when a local input source is properly loaded' do
      it 'saves the file without a provided filename' do
        local_input_source.write_to_file(output_dir)
        rendered_file = "#{output_dir}/default_sample.jpg"
        expect(File.exist?(output_dir)).to be true
        expect(FileUtils.compare_file(rendered_file, input_file)).to be true
      end

      it 'saves the file with a provided filename' do
        local_input_source.write_to_file("#{output_dir}/custom_filename.jpg")
        custom_file = "#{output_dir}/custom_filename.jpg"
        expect(File.exist?(custom_file)).to be true
        expect(FileUtils.compare_file(custom_file, input_file)).to be true
      end
    end

    after(:each) do
      FileUtils.rm_f("#{output_dir}/default_sample.jpg")
      FileUtils.rm_f("#{output_dir}/custom_filename.jpg")
    end
  end
end
