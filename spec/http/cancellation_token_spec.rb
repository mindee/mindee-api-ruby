# frozen_string_literal: true

require 'mindee'

describe Mindee::HTTP::CancellationToken do
  it 'starts in a not-cancelled state' do
    token = described_class.new
    expect(token.canceled?).to be false
  end

  it 'is cancelled after calling #cancel' do
    token = described_class.new
    token.cancel
    expect(token.canceled?).to be true
  end

  it 'remains cancelled once cancel has been called' do
    token = described_class.new
    token.cancel
    token.cancel
    expect(token.canceled?).to be true
  end
end
