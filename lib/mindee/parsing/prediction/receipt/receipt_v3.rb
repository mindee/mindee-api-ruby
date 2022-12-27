# frozen_string_literal: true

require_relative '../common_fields'
require_relative '../base'

module Mindee
  # Receipt document.
  class ReceiptV3 < Prediction
    # @return [Mindee::Locale]
    attr_reader :locale
    # @return [Mindee::Amount]
    attr_reader :total_incl
    # @return [Mindee::Amount]
    attr_reader :total_excl
    # @return [Mindee::Amount]
    attr_reader :total_tax
    # @return [Mindee::DateField]
    attr_reader :date
    # @return [Mindee::Field]
    attr_reader :supplier
    # @return [Array<Mindee::TaxField>]
    attr_reader :taxes
    # @return [Mindee::Orientation]
    attr_reader :orientation
    # @return [Mindee::Field]
    attr_reader :time
    # @return [Mindee::Field]
    attr_reader :category

    # @param prediction [Hash]
    # @param page_id [Integer, nil]
    def initialize(prediction, page_id)
      super()
      @locale = Locale.new(prediction['locale'])
      @total_incl = Amount.new(prediction['total_incl'], page_id)
      @date = DateField.new(prediction['date'], page_id)
      @category = Field.new(prediction['category'], page_id)
      @supplier = Field.new(prediction['supplier'], page_id)
      @time = Field.new(prediction['time'], page_id)
      @taxes = []
      prediction['taxes'].each do |item|
        @taxes.push(TaxField.new(item, page_id))
      end

      @total_tax = Amount.new(
        { value: nil, confidence: 0.0 }, page_id
      )
      @total_excl = Amount.new(
        { value: nil, confidence: 0.0 }, page_id
      )
      reconstruct(page_id)
    end

    def to_s
      taxes = @taxes.join("\n       ")
      out_str = String.new
      out_str << '-----Receipt data-----'
      out_str << "\nFilename: #{@filename}".rstrip
      out_str << "\nTotal amount including taxes: #{@total_incl}".rstrip
      out_str << "\nTotal amount excluding taxes: #{@total_excl}".rstrip
      out_str << "\nDate: #{@date}".rstrip
      out_str << "\nCategory: #{@category}".rstrip
      out_str << "\nTime: #{@time}".rstrip
      out_str << "\nMerchant name: #{@supplier}".rstrip
      out_str << "\nTaxes: #{taxes}".rstrip
      out_str << "\nTotal taxes: #{@total_tax}".rstrip
      out_str << "\nLocale: #{@locale}".rstrip
      out_str << "\n----------------------"
      out_str
    end

    private

    def reconstruct(page_id)
      construct_total_tax_from_taxes(page_id)
      construct_total_excl(page_id)
    end

    def construct_total_tax_from_taxes(page_id)
      return if @taxes.empty? || !@total_tax.value.nil?

      total_tax = {
        'value' => @taxes.map do |tax|
          if tax.value.nil?
            0
          else
            tax.value
          end
        end.sum,
        'confidence' => Field.array_confidence(@taxes),
      }
      return unless total_tax['value'].positive?

      @total_tax = Amount.new(total_tax, page_id, reconstructed: true)
    end

    def construct_total_excl(page_id)
      return if @taxes.empty? || @total_incl.value.nil?

      total_excl = {
        'value' => @total_incl.value - Field.array_sum(@taxes),
        'confidence' => Field.array_confidence(@taxes) * @total_incl.confidence,
      }
      @total_excl = Amount.new(total_excl, page_id, reconstructed: true)
    end
  end
end
