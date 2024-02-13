require 'json'
require 'mindee/product'
require 'mindee/parsing'

require_relative '../data'

RSpec.describe "International ID v1 document" do
  let(:complete_doc_data) do
    Mindee::Parsing::Common::Document.new(Mindee::Product::Generated::GeneratedV1, JSON.parse(File.read(File.join(DATA_DIR, "products", "generated", "response_v1", "complete_international_id_v1.json")))["document"])
  end

  let(:empty_doc_data) do
    Mindee::Parsing::Common::Document.new(Mindee::Product::Generated::GeneratedV1, JSON.parse(File.read(File.join(DATA_DIR, "products", "generated", "response_v1", "empty_international_id_v1.json")))["document"])
  end

  let(:complete_doc_str) do
    Mindee::Parsing::Common::Document.new(Mindee::Product::Generated::GeneratedV1, File.read(File.join(DATA_DIR, "products", "generated", "response_v1", "summary_full_international_id_v1.rst", encoding: "utf-8"))["document"])
  end

  let(:empty_doc_str) do
    Mindee::Parsing::Common::Document.new(Mindee::Product::Generated::GeneratedV1, File.read(File.join(DATA_DIR, "products", "generated", "response_v1", "summary_empty_international_id_v1.rst", encoding: "utf-8"))["document"])
  end

  describe "Empty document" do
    it "ensures all fields are empty" do
      # Parse the JSON data and perform necessary assertions
      expect(empty_doc_data.inference.prediction.fields["document_type"].value).to be_nil
      expect(empty_doc_data.inference.prediction.fields["document_number"].value).to be_nil
      # Add more assertions for other fields
    end
  end

  describe "Complete document" do
    it "ensures all fields are populated correctly" do
      # Parse the JSON data and perform necessary assertions
      expect(complete_doc_data.inference.prediction.fields["document_type"].value).to eq("NATIONAL_ID_CARD")
      expect(complete_doc_data.inference.prediction.fields["document_number"].value).to eq("99999999R")
      # Add more assertions for other fields
    end
  end

  describe "String representation" do
    it "matches the expected string for empty document" do
      # Perform assertions for string representation
      expect(str(international_id_v1_empty_doc)).to eq(empty_doc_str)
    end

    it "matches the expected string for complete document" do
      # Perform assertions for string representation
      expect(str(international_id_v1_complete_doc)).to eq(complete_doc_str)
    end
  end
end
