# frozen_string_literal: true

require 'mindee'

describe Mindee::Parsing::Standard::DateField do
  describe 'constructor with date' do
    let(:field_dict) do
      {
        'value' => '2018-04-01',
        'confidence' => 0.1,
        'polygon' => [
          [0.016, 0.707],
          [0.414, 0.707],
          [0.414, 0.831],
          [0.016, 0.831],
        ],
        'is_computed' => true,
      }
    end

    it 'sets value' do
      field = Mindee::Parsing::Standard::DateField.new(field_dict, 0)
      expect(field.value).to eq('2018-04-01')
      expect(field.date_object).to be_a(Date)
      expect(field.is_computed).to be(true)
    end
  end

  describe 'constructor with no date' do
    let(:field_dict) do
      {
        'confidence' => 0,
        'polygon' => [],
      }
    end

    it 'sets no date' do
      field = Mindee::Parsing::Standard::DateField.new(field_dict, 0)
      expect(field.value).to be_nil
    end
  end
end
