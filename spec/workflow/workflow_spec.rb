# frozen_string_literal: true

require 'json'
require 'mindee'
require_relative '../data'

describe Mindee::Client do
  describe 'execute_workflow' do
    it 'should deserialize response correctly when sending a document to an execution' do
      json_file_path = "#{DATA_DIR}/workflows/success.json"
      mock_response = JSON.parse(File.read(json_file_path))

      mocked_response = MockHTTPResponse.new('1.0', '202', 'OK', JSON.generate(mock_response))

      allow(Net::HTTP).to receive(:start).and_return(mocked_response)

      mocked_execution = Mindee::Parsing::Common::WorkflowResponse.new(
        GeneratedV1,
        JSON.parse(mocked_response.body, object_class: Hash),
        mocked_response.body
      )
      expect(mocked_execution).not_to be_nil
      expect(mocked_execution.api_request).not_to be_nil
      expect(mocked_execution.execution.batch_name).to be_nil
      expect(mocked_execution.execution.created_at).to be_nil
      expect(mocked_execution.execution.file.alias).to be_nil
      expect(mocked_execution.execution.file.name).to eq('default_sample.jpg')
      expect(mocked_execution.execution.id).to eq('8c75c035-e083-4e77-ba3b-7c3598bd1d8a')
      expect(mocked_execution.execution.inference).to be_nil
      expect(mocked_execution.execution.priority).to eq(:medium)
      expect(mocked_execution.execution.reviewed_at).to be_nil
      expect(mocked_execution.execution.reviewed_prediction).to be_nil
      expect(mocked_execution.execution.status).to eq('processing')
      expect(mocked_execution.execution.type).to eq('manual')
      expect(
        mocked_execution.execution.uploaded_at.strftime('%Y-%m-%dT%H:%M:%S.%6N')
      ).to eq('2024-11-13T13:02:31.699190')
      expect(mocked_execution.execution.workflow_id).to eq('07ebf237-ff27-4eee-b6a2-425df4a5cca6')
    end

    it 'should deserialize response correctly when sending a document to an execution with priority and alias' do
      json_file_path = "#{DATA_DIR}/workflows/success_low_priority.json"
      mock_response = JSON.parse(File.read(json_file_path))

      mocked_response = MockHTTPResponse.new('1.0', '200', 'OK', JSON.generate(mock_response))

      allow(Net::HTTP).to receive(:start).and_return(mocked_response)

      mocked_execution = Mindee::Parsing::Common::WorkflowResponse.new(
        GeneratedV1,
        JSON.parse(mocked_response.body, object_class: Hash),
        mocked_response.body
      )

      expect(mocked_execution).not_to be_nil
      expect(mocked_execution.api_request).not_to be_nil
      expect(mocked_execution.execution.batch_name).to be_nil
      expect(mocked_execution.execution.created_at).to be_nil
      expect(mocked_execution.execution.file.alias).to eq('low-priority-sample-test')
      expect(mocked_execution.execution.file.name).to eq('default_sample.jpg')
      expect(mocked_execution.execution.id).to eq('b743e123-e18c-4b62-8a07-811a4f72afd3')
      expect(mocked_execution.execution.inference).to be_nil
      expect(mocked_execution.execution.priority).to eq(:low)
      expect(mocked_execution.execution.reviewed_at).to be_nil
      expect(mocked_execution.execution.reviewed_prediction).to be_nil
      expect(mocked_execution.execution.status).to eq('processing')
      expect(mocked_execution.execution.type).to eq('manual')
      expect(
        mocked_execution.execution.uploaded_at.strftime('%Y-%m-%dT%H:%M:%S.%6N')
      ).to eq('2024-11-13T13:17:01.315179')
      expect(mocked_execution.execution.workflow_id).to eq('07ebf237-ff27-4eee-b6a2-425df4a5cca6')
    end
  end
end
