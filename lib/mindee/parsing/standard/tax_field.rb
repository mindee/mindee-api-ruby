# frozen_string_literal: true

require_relative 'base_field'

module Mindee
  module Parsing
    module Standard
      # Represents tax information.
      class TaxField < Field
        # Tax value as 3 decimal float
        # @return [Float, nil]
        attr_reader :value
        # Tax rate percentage
        # @return [Float]
        attr_reader :rate
        # Tax code
        # @return [String]
        attr_reader :code
        # Tax base
        # @return [Float]
        attr_reader :base

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @value = prediction['value']&.round(3)
          @rate = prediction['rate'].to_f unless prediction['rate'].nil?
          @base = prediction['base'].to_f unless prediction['base'].nil?
          @code = prediction['code'] unless prediction['code'] == 'None'
        end

        # @param value [Float]
        def print_float(value)
          format('%.2f', value)
        end

        # @return [String]
        def to_s
          printable = printable_values
          out_str = String.new
          out_str << ("Base: #{printable[:base]}")
          out_str << (", Code: #{printable[:code]}")
          out_str << (", Rate (%): #{printable[:rate]}")
          out_str << (", Amount: #{printable[:value]}")
          out_str.strip
        end

        # @return [Hash]
        def printable_values
          out_h = {}
          out_h[:code] = @code.nil? ? '' : @code
          out_h[:base] = @base.nil? ? '' : print_float(@base)
          out_h[:rate] = @rate.nil? ? '' : print_float(@rate).to_s
          out_h[:value] = @value.nil? ? '' : print_float(@value).to_s
          out_h
        end

        # @return [String]
        def to_table_line
          printable = printable_values
          out_str = String.new
          out_str << ("| #{printable[:base].ljust(13, ' ')}")
          out_str << (" | #{printable[:code].ljust(6, ' ')}")
          out_str << (" | #{printable[:rate].ljust(8, ' ')}")
          out_str << (" | #{printable[:value].ljust(13, ' ')} |")
          out_str.strip
        end
      end

      # Represents tax information, grouped as an array.
      class Taxes < Array
        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super(prediction.map { |entry| TaxField.new(entry, page_id) })
        end

        # @param char [String]
        # @return [String]
        def line_separator(char)
          out_str = String.new
          out_str << '  '
          out_str << "+#{char * 15}"
          out_str << "+#{char * 8}"
          out_str << "+#{char * 10}"
          out_str << "+#{char * 15}"
          out_str << '+'
          out_str
        end

        # @return [String]
        def to_s
          return '' if nil? || empty?

          out_str = String.new
          out_str << ("\n#{line_separator('-')}")
          out_str << "\n  | Base          | Code   | Rate (%) | Amount        |"
          out_str << "\n#{line_separator('=')}"
          each do |entry|
            out_str << "\n  #{entry.to_table_line}\n#{line_separator('-')}"
          end
          out_str
        end
      end

      class CustomTaxExtractor
        # Normalizes text by removing diacritics.
        # @param input_str [String] string to handle.
        # @return [String]
        def self.remove_accents(input_str)
          diacritics = [*0x1DC0..0x1DFF, *0x0300..0x036F, *0xFE20..0xFE2F].pack('U*')
          input_str
            .unicode_normalize(:nfd)
            .tr(diacritics, '')
            .unicode_normalize(:nfc)
        end

        # Checks for a list of possible matches in a string. Case & diacritics insensitive.
        # @param text [String] string to search for matches.
        # @param matches [Array<String>] array of values to look for
        # @return [Boolean]
        def self.match_index(text, matches)
          matches.each do |match|
            return remove_accents(text.downcase).index(remove_accents(match.downcase)) unless remove_accents(text.downcase).index(remove_accents(match.downcase)).nil?
          end
          nil
        end

        def self.extract_numeric_part(amount_str)
          # Remove non-numeric characters except for dots and commas
          cleaned_str = amount_str.gsub(%r{[^\d.,]}, '')

          # If the cleaned string ends with a comma, remove it
          cleaned_str.sub!(%r{,$}, '')

          # Replace commas with an empty string for proper float conversion
          cleaned_str.gsub!(',', '')

          # Extract the numeric part of the string
          cleaned_str.sub(%r{^[^\d]+}, '')
        end

        def self.parse_amount(amount_str)
          cleaned_str = amount_str.gsub(%r{[^\d.,]}, '')
          cleaned_str.sub!(%r{,$}, '')
          extract_numeric_part(cleaned_str)
          numeric_part = cleaned_str.sub(%r{^[^\d]+}, '')
          numeric_part.gsub!(',', '.')
          Float(numeric_part)
        rescue ArgumentError
          nil
        end

        def self.parse_percentage(percentage_str)
          percentage_str.gsub!('%', '')
          percentage_str.strip
          percentage_str.gsub!(',', '.')
          Float(percentage_str)
        rescue ArgumentError
          nil
        end

        def self.extract_from_line(line, pattern, page_id)
          found_hash = {}

          matches = line.gsub(%r{[-+]}, '').match(pattern)

          # Edge case for when the tax is split-up between two pages, we'll consider as belonging to the first one
          found_hash['page_id'] = page_id unless found_hash.key?('page_id')
          found_hash['code'] = matches[1] unless matches[1].nil?
          found_hash['rate'] = parse_percentage(matches[2]) unless matches[2].nil?
          if matches[4].nil? && !matches[3].nil?
            found_hash['value'] = parse_amount(matches[3]) unless matches[3].nil?
          elsif matches[3].nil? && !matches[4].nil?
            found_hash['value'] = parse_amount(matches[4]) unless matches[4].nil?
          elsif !matches[3].nil? && !matches[4].nil?
            found_hash['basis'] = parse_amount(matches[3]) unless matches[3].nil?
            found_hash['value'] = parse_amount(matches[4]) unless matches[4].nil?
          end
          found_hash
        end

        def self.extract_horizontal(ocr_result, tax_names)
          linear_pattern = %r{\s*([a-zA-Z]+[a-zA-Z\s]*\s*)[(\[]?\s*(\s*\d*[.,]?\d+\s*%?|%?\s*\d*[.,]?\d+\s*)?\s*[)\]]?\s*(\d*[.,]?\d+|\d+)?\s+(\d*[.,]?\d+|\d+)?}
          ocr_result.mvision_v1.pages.each_with_index do |page, page_id|
            page.all_lines.each do |line|
              unless match_index(line.to_s, tax_names).nil? || line.to_s.gsub(%r{[-+]}, '').match(linear_pattern).nil?
                return extract_from_line(line.to_s[match_index(line.to_s, tax_names)..-1], linear_pattern, page_id)
              end
            end
          end
          {}
        end

        def self.extract_vertical(ocr_result, tax_names, found_hash)
          ocr_result.mvision_v1.pages.each_with_index do |page, page_id|
            page.all_words.each do |word|
              next if match_index(word.text, tax_names).nil?

              line = ocr_result.reconstruct_vertically(word.polygon, page_id)
              found_hash['page_id'] = page_id unless found_hash.key?('page_id')
              found_hash['code'] = word.text unless found_hash.key?('code')
              amounts = []
              line.each do |reconstructed_word|
                amounts.push(parse_amount(reconstructed_word.text)) unless parse_amount(reconstructed_word.text).nil?
              end
              if amounts.length == 1 && !found_hash.key?('value')
                found_hash['value'] = amounts[0]
              else
                found_hash['rate'] = amounts[0] unless found_hash.key?('rate')
                found_hash['value'] = amounts[1] unless found_hash.key?('value')
              end
            end
          end
          found_hash
        end

        # Extracts a single custom type of tax.
        # For the sake of simplicity, this only extracts the first example, unless specifically instructed otherwise.
        # @param ocr_result [Mindee::Parsing::Common::Ocr::Ocr] result of the OCR.
        # @param tax_names [Array<String>] list of all possible names the tax can have.
        # @return [TaxField, nil]
        def self.extract_custom_tax(ocr_result, tax_names)
          return nil if ocr_result.is_a?(Mindee::Parsing::Common::Ocr) || tax_names.empty?

          found_hash = extract_horizontal(ocr_result, tax_names)
          # a tax is considered found horizontally if it has a value, otherwise it is vertical
          found_hash = extract_vertical(ocr_result, tax_names, found_hash)

          return if found_hash.empty?

          TaxField.new(found_hash,
                       found_hash.key?('page_id') ? found_hash['page_id'] : nil)
        end
      end
    end
  end
end
