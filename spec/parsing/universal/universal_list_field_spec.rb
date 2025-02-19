# frozen_string_literal: true

require 'mindee'

describe Mindee::Parsing::Universal::UniversalListField do
  let(:raw_prediction) { [{ 'value' => 'Item1' }, { 'value' => 'Item2' }] }
  subject(:universal_list_field) { described_class.new(raw_prediction) }

  describe '#contents_list' do
    it 'returns an array with the string representations of each value' do
      expect(universal_list_field.contents_list).to eq(['Item1', 'Item2'])
    end

    context 'when initialized with an empty array' do
      let(:raw_prediction) { [] }
      it 'returns an empty array' do
        expect(universal_list_field.contents_list).to be_empty
      end
    end
  end

  describe '#contents_string' do
    it 'returns a space-separated string of the values by default' do
      expect(universal_list_field.contents_string).to eq('Item1 Item2')
    end

    it 'returns a string with a custom separator when provided' do
      expect(universal_list_field.contents_string(',')).to eq('Item1,Item2')
    end
  end

  describe '#to_s' do
    it 'returns the same output as the default contents_string' do
      expect(universal_list_field.to_s).to eq(universal_list_field.contents_string)
    end
  end
end
