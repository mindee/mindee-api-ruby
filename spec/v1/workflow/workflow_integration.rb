# frozen_string_literal: true

require 'json'
require 'mindee'
require_relative '../../data'

describe Mindee::Client do
  describe 'execute_workflow call to API' do
    let(:client) { Mindee::Client.new }
    let(:sample_input) do
      Mindee::Input::Source::PathInputSource.new(
        File.join(V1_PRODUCT_DATA_DIR, 'financial_document', 'default_sample.jpg')
      )
    end
    let(:workflow_id) { ENV.fetch('WORKFLOW_ID') }
    it 'should return a valid response' do
      current_date_time = Time.now.strftime('%Y-%m-%d-%H:%M:%S')
      document_alias = "ruby-#{current_date_time}"
      priority = Mindee::Parsing::Common::ExecutionPriority::LOW

      response = client.execute_workflow(
        sample_input,
        workflow_id,
        options: { document_alias: document_alias,
                   priority: priority, rag: true }
      )

      expect(response.execution.file.alias).to eq(document_alias)
      expect(response.execution.priority).to eq(priority)
    end

    it 'should poll a workflow with RAG' do
      options = { workflow_id: workflow_id, rag: true }
      response = client.parse(
        sample_input,
        Mindee::Product::FinancialDocument::FinancialDocumentV1,
        options: options
      )
      expect(response.document.to_s).to_not be_empty
      expect(response.document.inference.extras.rag.matching_document_id).to_not be_empty
    end

    it 'should poll a workflow without RAG' do
      options = { workflow_id: workflow_id }
      response = client.parse(
        sample_input,
        Mindee::Product::FinancialDocument::FinancialDocumentV1,
        options: options
      )
      expect(response.document.to_s).to_not be_empty
      expect(response.document.inference.extras.rag).to be_nil
    end
  end
end
