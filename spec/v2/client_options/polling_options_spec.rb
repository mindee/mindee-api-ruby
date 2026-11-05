# frozen_string_literal: true

require 'mindee'
require 'mindee/input'

describe Mindee::Input::PollingOptions do
  it 'provides sensible defaults' do
    options = Mindee::Input::PollingOptions.new
    expect(options.initial_delay_sec).to eq(2.0)
    expect(options.delay_sec).to eq(1.5)
    expect(options.max_retries).to eq(80)
  end

  it 'allows custom values' do
    options = Mindee::Input::PollingOptions.new(
      initial_delay_sec: 3.0,
      delay_sec: 5.0,
      max_retries: 100
    )
    expect(options.initial_delay_sec).to eq(3.0)
    expect(options.delay_sec).to eq(5.0)
    expect(options.max_retries).to eq(100)
  end

  it 'raises an error with invalid options' do
    expect do
      Mindee::Input::PollingOptions.new(
        initial_delay_sec: -1.0,
        delay_sec: 1.5,
        max_retries: 80
      )
    end.to raise_error(ArgumentError)

    expect do
      Mindee::Input::PollingOptions.new(
        initial_delay_sec: 2.0,
        delay_sec: -1.5,
        max_retries: 80
      )
    end.to raise_error(ArgumentError)

    expect do
      Mindee::Input::PollingOptions.new(
        initial_delay_sec: 2.0,
        delay_sec: 1.5,
        max_retries: -1
      )
    end.to raise_error(ArgumentError)
  end
end
