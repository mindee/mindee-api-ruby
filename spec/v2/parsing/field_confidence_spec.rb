# frozen_string_literal: true

require 'mindee'
require 'mindee/v2/parsing/field'

describe Mindee::V2::Parsing::Field::FieldConfidence do
  let(:certain) { described_class.new('Certain') }
  let(:high)    { described_class.new('High') }
  let(:medium)  { described_class.new('Medium') }
  let(:low)     { described_class.new('Low') }

  describe '#>' do
    it 'returns true when this confidence is greater than a FieldConfidence' do
      expect(high > medium).to be true
      expect(certain > low).to be true
    end

    it 'returns false when this confidence is less than a FieldConfidence' do
      expect(medium > high).to be false
    end

    it 'returns false when both confidences are equal' do
      expect(high > described_class.new('High')).to be false
    end

    it 'compares against a String' do
      expect(high > 'Medium').to be true
      expect(low > 'High').to be false
    end

    it 'compares against an Integer' do
      expect(high > 2).to be true
      expect(low > 3).to be false
    end

    it 'raises ArgumentError for invalid types' do
      expect { high > :invalid }.to raise_error(ArgumentError)
    end
  end

  describe '#<' do
    it 'returns true when this confidence is less than a FieldConfidence' do
      expect(medium < high).to be true
      expect(low < certain).to be true
    end

    it 'returns false when this confidence is greater than a FieldConfidence' do
      expect(high < medium).to be false
    end

    it 'returns false when both confidences are equal' do
      expect(medium < described_class.new('Medium')).to be false
    end

    it 'compares against a String' do
      expect(medium < 'High').to be true
      expect(high < 'Low').to be false
    end

    it 'compares against an Integer' do
      expect(low < 3).to be true
      expect(certain < 1).to be false
    end

    it 'raises ArgumentError for invalid types' do
      expect { low < :invalid }.to raise_error(ArgumentError)
    end
  end

  describe 'named aliases' do
    describe '#greater_than? / #gt?' do
      it 'is an alias for >' do
        expect(high.greater_than?(medium)).to be true
        expect(medium.greater_than?(high)).to be false
        expect(high.greater_than?(described_class.new('High'))).to be false
        expect(high.gt?(medium)).to be true
        expect(medium.gt?(high)).to be false
      end
    end

    describe '#less_than? / #lt?' do
      it 'is an alias for <' do
        expect(medium.less_than?(high)).to be true
        expect(high.less_than?(medium)).to be false
        expect(medium.less_than?(described_class.new('Medium'))).to be false
        expect(medium.lt?(high)).to be true
        expect(high.lt?(medium)).to be false
      end
    end

    describe '#greater_than_or_equal? / #gteql?' do
      it 'is an alias for >=' do
        expect(high.greater_than_or_equal?(medium)).to be true
        expect(high.greater_than_or_equal?(described_class.new('High'))).to be true
        expect(low.greater_than_or_equal?(medium)).to be false
        expect(high.gteql?(medium)).to be true
      end
    end

    describe '#less_than_or_equal? / #lteql?' do
      it 'is an alias for <=' do
        expect(medium.less_than_or_equal?(high)).to be true
        expect(medium.less_than_or_equal?(described_class.new('Medium'))).to be true
        expect(high.less_than_or_equal?(low)).to be false
        expect(medium.lteql?(high)).to be true
      end
    end

    describe '#equal? / #eql?' do
      it 'returns true for equal confidence values' do
        expect(high.equal?(described_class.new('High'))).to be true
        expect(high.eql?(described_class.new('High'))).to be true
      end

      it 'returns false for different confidence values' do
        expect(high.equal?(medium)).to be false
        expect(high.eql?(low)).to be false
      end

      it 'compares against a String' do
        expect(high.equal?('High')).to be true
        expect(high.equal?('Medium')).to be false
      end

      it 'compares against an Integer' do
        expect(high.equal?(3)).to be true
        expect(high.equal?(2)).to be false
      end
    end
  end
end
