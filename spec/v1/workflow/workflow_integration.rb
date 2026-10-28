# frozen_string_literal: true

require 'json'
require 'mindee'
require_relative '../../data'

describe Mindee::V1::Client do
  describe 'execute_workflow call to API' do
    let(:client) { Mindee::V1::Client.new }
    let(:sample_input) do
      Mindee::Input::Source::PathInputSource.new(
        File.join(V1_PRODUCT_DATA_DIR, 'financial_document', 'default_sample.jpg')
      )
    end
    let(:workflow_id) { ENV.fetch('WORKFLOW_ID') }

    it 'should poll a workflow with RAG' do
      options = { workflow_id: workflow_id, rag: true }
      response = client.parse(
        sample_input,
        Mindee::V1::Product::FinancialDocument::FinancialDocumentV1,
        options: options
      )
      expect(response.document.to_s).to_not be_empty
      expect(response.document.inference.extras.rag.matching_document_id).to_not be_empty
    end

    it 'should poll a workflow without RAG' do
      options = { workflow_id: workflow_id }
      response = client.parse(
        sample_input,
        Mindee::V1::Product::FinancialDocument::FinancialDocumentV1,
        options: options
      )
      expect(response.document.to_s).to_not be_empty
      expect(response.document.inference.extras.rag).to be_nil
    end
  end
end
