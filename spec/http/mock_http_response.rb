# frozen_string_literal: true

require 'json'

class MockHTTPResponse < Net::HTTPSuccess
  attr_writer :mock_code

  def initialize(version, code, message, hash_data)
    super(version, code, message)
    @mock_body = hash_data
  end

  def body
    @mock_body || super
  end
end
