# frozen_string_literal: true

require_relative '../fields'
require_relative 'base'

module Mindee
  # Receipt document.
  class Receipt < Document
    attr_reader :locale,
                :total_incl,
                :total_excl,
                :date,
                :time,
                :category,
                :merchant_name,
                :taxes,
                :total_tax,
                :orientation

    def initialize(prediction, page_id)
      super('receipt')
      @orientation = Orientation.new(prediction['orientation'], page_id) if page_id
      @locale = Locale.new(prediction['locale'])
      @total_incl = Field.new(prediction['total_incl'], page_id)
      @date = DateField.new(prediction['date'], page_id)
      @category = Field.new(prediction['category'], page_id)
      @merchant_name = Field.new(prediction['supplier'], page_id)
      @time = Field.new(prediction['time'], page_id)
      @taxes = []
      prediction['taxes'].each do |item|
        @taxes.push(Tax.new(item, page_id))
      end
      @total_tax = make_total_tax(page_id)
      @total_excl = make_total_excl(page_id)
    end

    def to_s
      taxes = @taxes.join(' ')
      out_str = String.new
      out_str << '-----Receipt data-----'
      out_str << "\nFilename: #{@filename}".rstrip
      out_str << "\nTotal amount including taxes: #{@total_incl}".rstrip
      out_str << "\nTotal amount excluding taxes: #{@total_excl}".rstrip
      out_str << "\nDate: #{@date}".rstrip
      out_str << "\nCategory: #{@category}".rstrip
      out_str << "\nTime: #{@time}".rstrip
      out_str << "\nMerchant name: #{@merchant_name}".rstrip
      out_str << "\nTaxes: #{taxes}".rstrip
      out_str << "\nTotal taxes: #{@total_tax}".rstrip
      out_str << "\nLocale: #{@locale}".rstrip
      out_str << "\n----------------------"
      out_str
    end

    private

    def make_total_tax(page_id)
      return unless !@taxes.empty? &&
                    !@total_tax

      total_tax = {
        'value' => @taxes.map(&:value).sum,
        'confidence' => Field.array_confidence(@taxes),
      }
      Field.new(total_tax, page_id, reconstructed: true)
    end

    def make_total_excl(page_id)
      return unless !@taxes.empty? &&
                    @total_incl&.value

      total_excl = {
        'value' => @total_incl.value - Field.array_sum(@taxes),
        'confidence' => Field.array_confidence(@taxes) * @total_incl.confidence,
      }
      Field.new(total_excl, page_id, reconstructed: true)
    end
  end
end
