# frozen_string_literal: true

require 'mindee'

describe Mindee::Parsing::Standard::StringField do
  describe 'constructor without raw_value' do
    let(:field_dict) do
      {
        'value' => 'hello world',
        'confidence' => 0.1,
        'polygon' => [
          [0.016, 0.707],
          [0.414, 0.707],
          [0.414, 0.831],
          [0.016, 0.831],
        ],
      }
    end

    it 'sets value and raw_value to nil' do
      field = Mindee::Parsing::Standard::StringField.new(field_dict)
      expect(field.value).to eq('hello world')
      expect(field.raw_value).to be_nil
    end
  end

  describe 'constructor with raw_value' do
    let(:field_dict) do
      {
        'value' => 'hello world',
        'raw_value' => 'HelLO wOrld',
        'confidence' => 0.1,
        'polygon' => [
          [0.016, 0.707],
          [0.414, 0.707],
          [0.414, 0.831],
          [0.016, 0.831],
        ],
      }
    end

    it 'sets value and raw_value accordingly' do
      field = Mindee::Parsing::Standard::StringField.new(field_dict)
      expect(field.value).to eq('hello world')
      expect(field.raw_value).to eq('HelLO wOrld')
    end
  end
end
