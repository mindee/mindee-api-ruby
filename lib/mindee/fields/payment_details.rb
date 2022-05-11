# frozen_string_literal: true

require_relative 'base'

module Mindee
  class PaymentDetails < Field
    attr_reader :account_number,
                :iban,
                :routing_number,
                :swift

    def initialize(prediction, page_id, constructed: nil)
      super
      @account_number = prediction['account_number']
      @iban = prediction['iban']
      @routing_number = prediction['routing_number']
      @swift = prediction['swift']
    end

    def to_s
      out_str = String.new
      out_str << "#{@account_number};" if @account_number
      out_str << "#{@iban};" if @iban
      out_str << "#{@routing_number};" if @routing_number
      out_str << "#{@swift};" if @swift
      out_str.strip
    end
  end
end
