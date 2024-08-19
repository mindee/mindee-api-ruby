# frozen_string_literal: true

module Mindee
  module Extraction
    # Generic extractor class
    class OcrExtractor
      # Checks for a list of possible matches in a string & returns the index of the first found candidate.
      # Case & diacritics insensitive.
      # @param text [String] string to search for matches.
      # @param str_candidates [Array<String>] array of values to look for
      # @return [Integer, nil]
      def self.match_index(text, str_candidates)
        idx = nil
        str_candidates.each do |str_candidate|
          found_idx = remove_accents(text.downcase).index(remove_accents(str_candidate.downcase))
          idx = found_idx if idx.nil?
          idx = found_idx if !found_idx.nil? && found_idx >= idx
        end
        idx
      end

      # Normalizes text by removing diacritics.
      # @param input_str [String] string to handle.
      # @return [String]
      def self.remove_accents(input_str)
        diacritics = [*0x1DC0..0x1DFF, *0x0300..0x036F, *0xFE20..0xFE2F].pack('U*')
        input_str
          .unicode_normalize(:nfd)
          .tr(diacritics, '')
          .unicode_normalize(:nfc)
          .scrub
      end

      # Checks if a given percentage value is within the allowed range
      # @param value [Integer] The value to check
      # @param min_rate_percentage [Integer] Minimum allowed rate on the tax.
      # @param max_rate_percentage [Integer] Maximum allowed rate on the tax.
      # @return [Boolean]
      def self.valid_percentage?(value, min_rate_percentage, max_rate_percentage)
        return false if value.nil?

        value > min_rate_percentage && value < max_rate_percentage
      end

      # Parses a percentage from a string, and returns it as a float.
      # Returns nil if candidate isn't a valid percentage.
      # @param percentage_str [String] String candidate.
      # @return [Float, nil]
      def self.parse_percentage(percentage_str)
        percentage_str.gsub!('%', '')
        percentage_str.strip
        percentage_str.gsub!(',', '.')
        Float(percentage_str.scrub)
      rescue ArgumentError
        nil
      end

      # Parses an amount from a string, and returns it as a float.
      # Returns nil if candidate isn't a valid amount.
      # @param amount_str [String] String candidate.
      # @return [Float, nil]
      def self.parse_amount(amount_str)
        cleaned_str = amount_str.gsub(' ', '')
        cleaned_str = standardize_delimiters(cleaned_str)
        Float(cleaned_str)
      rescue ArgumentError
        nil
      end

      private

      def self.standardize_delimiters(str)
        if comma_decimal?(str)
          str.gsub('.', '').gsub(',', '.')
        elsif dot_decimal?(str)
          str.gsub(',', '')
        else
          str
        end
      end

      def self.comma_decimal?(str)
        (str.length > 3 && str[-3] == ',') || str[-2] == ','
      end

      def self.dot_decimal?(str)
        (str.length > 3 && str[-3] == '.') || str[-2] == '.'
      end

      # Removes most common currency symbols from string
      # @param input_string [String] string to remove the symbols from
      # @return [String]
      def self.remove_currency_symbols(input_string)
        # Define an array of common currency symbols
        currency_symbols = ['$', '€', '£', '¥', '₹', '₽', '฿', '₺', '₴', '₿', '₡', '₮', '₱', '₲', '₪', '₫', '₩', '₵',
                            '₦', '₢', '₤', '₣', '₧', '₯', '₠', '₶', '₸', '₷', '₼', '₾', '₺', '﹩', '₨', '₹', '＄', '﹫']

        # Iterate over each currency symbol and remove it from the input string
        currency_symbols.each do |symbol|
          input_string.gsub!(symbol, '')
        end

        input_string
      end

      private_class_method :remove_accents, :match_index, :parse_amount, :parse_percentage, :remove_currency_symbols,
                           :valid_percentage?, :comma_decimal?, :dot_decimal?, :standardize_delimiters
    end
  end
end
