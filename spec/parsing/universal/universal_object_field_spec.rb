# frozen_string_literal: true

require 'mindee'

describe Mindee::Parsing::Universal::UniversalObjectField do
  let(:raw_prediction) do
    {
      'page_id' => 3,
      'confidence' => 0.85,
      'raw_value' => { 'info' => 'raw' },
      'custom_field' => 'TestValue',
      'extra_field' => 'Extra',
    }
  end
  subject(:object_field) { described_class.new(raw_prediction) }

  describe '#initialize' do
    it 'sets the page_id from the raw prediction' do
      expect(object_field.page_id).to eq(3)
    end

    it 'sets the confidence value' do
      expect(object_field.confidence).to eq(0.85)
    end

    it 'stores the raw_value correctly' do
      expect(object_field.raw_value).to eq({ 'info' => 'raw' })
    end
  end

  describe 'handling default fields' do
    it 'converts non-special fields to strings and makes them accessible' do
      expect(object_field.custom_field).to eq('TestValue')
      expect(object_field.extra_field).to eq('Extra')
    end

    it 'responds to dynamic methods for available fields' do
      expect(object_field.respond_to?(:custom_field)).to be true
      expect(object_field.respond_to?(:extra_field)).to be true
    end

    it 'does not respond to undefined fields' do
      expect(object_field.respond_to?(:undefined_field)).to be false
    end
  end

  describe '#str_level' do
    it 'returns a formatted string with the stored fields and proper indentation' do
      output = object_field.str_level(1)
      expect(output).to be_a(String)
      expect(output).to include(':custom_field: TestValue')
      expect(output).to include(':extra_field: Extra')
    end
  end

  describe 'method_missing behavior' do
    it 'raises NoMethodError for missing fields' do
      expect { object_field.nonexistent_field }.to raise_error(NoMethodError)
    end
  end

  context 'when raw_prediction includes a position field' do
    let(:rect_prediction) do
      {
        'page_id' => 5,
        'rectangle' => [[0.1, 0.2], [0.1, 0.3], [0.2, 0.1], [0.2, 0.3]],
        'useless_field' => 'ToCheckForNoErrors',
      }
    end
    subject(:object_field_with_rect) { described_class.new(rect_prediction) }

    it 'handles the position key by setting it as a PositionField instance' do
      position_field = object_field_with_rect.rectangle
      expect(position_field).to be_a(Mindee::Parsing::Standard::PositionField)
    end
  end

  describe '#to_s' do
    it 'returns the same output as calling str_level without arguments' do
      expect(object_field.to_s).to eq(object_field.str_level)
    end
  end
end
