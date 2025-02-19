# frozen_string_literal: true

require 'json'
require 'mindee'
require_relative '../data'

describe Mindee::Client do
  describe 'execute_workflow call to API' do
    let(:product_data_dir) { File.join(DATA_DIR, 'products') }
    it 'should return a valid response' do
      client = Mindee::Client.new
      invoice_splitter_input = Mindee::Input::Source::PathInputSource.new(
        File.join(product_data_dir, 'invoice_splitter', 'default_sample.pdf')
      )

      current_date_time = Time.now.strftime('%Y-%m-%d-%H:%M:%S')
      document_alias = "ruby-#{current_date_time}"
      priority = Mindee::Parsing::Common::ExecutionPriority::LOW

      response = client.execute_workflow(
        invoice_splitter_input,
        ENV.fetch('WORKFLOW_ID'),
        options: { document_alias: document_alias,
                   priority: priority }
      )

      expect(response.execution.file.alias).to eq(document_alias)
      expect(response.execution.priority).to eq(priority)
    end
  end
end
