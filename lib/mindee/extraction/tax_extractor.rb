# frozen_string_literal: true

module Mindee
  module Extraction
    # Tax extractor class
    class TaxExtractor
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

      # Checks for a list of possible matches in a string & returns the index of the first found candidate.
      # Case & diacritics insensitive.
      # @param text [String] string to search for matches.
      # @param candidates [Array<String>] array of values to look for
      # @return [Integer, nil]
      def self.match_index(text, candidates)
        candidates.each do |candidate|
          unless remove_accents(text.downcase).index(remove_accents(candidate.downcase)).nil?
            return remove_accents(text.downcase).index(remove_accents(candidate.downcase))
          end
        end
        nil
      end

      # Extracts the numeric part of a string, independently of commas & dots.
      # @param amount_str [String] String to process.
      # @return [String]
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

      # Parses an amount from a string, and returns it as a float.
      # Returns nil if candidate isn't a valid amount.
      # @param percentage_str [String] String candidate.
      # @return [Float, nil]
      def self.parse_amount(amount_str)
        cleaned_str = amount_str.scrub.gsub(%r{[^\d.,]}, '')
        cleaned_str.sub!(%r{,$}, '')
        extract_numeric_part(cleaned_str)
        numeric_part = cleaned_str.sub(%r{^[^\d]+}, '')
        numeric_part.gsub!(',', '.')
        Float(numeric_part)
      rescue ArgumentError
        nil
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

      # Extracts the rate and code, if found, from matches into the found_hash.
      # @param matches [MatchData] RegEx matches of the values for taxes
      # @param found_hash [Hash] Hash of currently retrieved values
      # @param percent_first [Boolean] Whether the percentage was found before or after the tax name.
      # @return [Hash]
      def self.extract_percentage(matches, found_hash, percent_first)
        if percent_first
          found_hash['code'] = matches[2].strip unless matches[2].nil?
          found_hash['rate'] = parse_percentage(matches[1]) unless matches[1].nil?
        else
          found_hash['code'] = matches[1].strip unless matches[1].nil?
          found_hash['rate'] = parse_percentage(matches[2]) unless matches[2].nil?
        end
        found_hash
      end

      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      # Extracts the basis and value of a tax from regex matches, independent of the order.
      # @param matches [MatchData] RegEx matches of the values for taxes
      # @param found_hash [Hash] Hash of currently retrieved values
      # @return [Hash]
      def self.extract_basis_and_value(matches, found_hash)
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
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      # Extracts tax information from a horizontal line.
      # @param line [String] Line to be processed.
      # @param pattern [Regexp] RegEx pattern to search the line with.
      # @param percent_first [Boolean] Whether the percentage was found before or after the tax name.
      # @return [Hash]
      def self.extract_from_horizontal_line(line, pattern, page_id, percent_first)
        found_hash = {}

        matches = line.match(pattern)

        # Edge case for when the tax is split-up between two pages, we'll consider that
        # the answer belongs to the first one.
        found_hash['page_id'] = page_id unless found_hash.key?('page_id')
        return found_hash if matches.nil?

        found_hash = extract_percentage(matches, found_hash, percent_first)
        extract_basis_and_value(matches, found_hash)
      end

      # Processes a horizontal line for tax extraction. Returns a hash of collected values.
      # @param ocr_result [Mindee::Parsing::Common::Ocr::Ocr] Processed OCR results.
      # @param tax_names [Array<String>] Possible tax names candidates.
      # @return [Hash]
      def self.extract_horizontal(ocr_result, tax_names)
        linear_pattern_percent_first = %r{
          \s*[(\[]*\s*(\s*\d*[.,]?\d+\s*%?|%?\s*\d*[.,]?\d+\s*)\s*[)\]]*\s*
          ([a-zA-Z]+[a-zA-Z\s]*\s*)
          (\d*[.,]?\d+|\d+)?\s+
          (\d*[.,]?\d+|\d+)?
        }x
        linear_pattern_percent_second = %r{
          \s*([a-zA-Z]+[a-zA-Z\s]*\s*)
          [(\[]*\s*(\s*\d*[.,]?\d+\s*%?|%?\s*\d*[.,]?\d+\s*)?\s*[)\]]*\s*
          (\d*[.,]?\d+|\d+)?\s+
          (\d*[.,]?\d+|\d+)?
        }x
        ocr_result.mvision_v1.pages.each_with_index do |page, page_id|
          page.all_lines.each do |line|
            clean_line = line.to_s.scrub.gsub(%r{[-+]}, '').to_s
            next if match_index(clean_line, tax_names).nil?

            if !clean_line.match(linear_pattern_percent_second).nil?
              return extract_from_horizontal_line(clean_line[match_index(clean_line, tax_names)..],
                                                  linear_pattern_percent_second, page_id, false)
            elsif !clean_line.match(linear_pattern_percent_first).nil?
              return extract_from_horizontal_line(clean_line[match_index(clean_line, ['%'])..],
                                                  linear_pattern_percent_first, page_id, true)
            else
              next
            end
          end
        end
        {}
      end

      # Processes a vertical reconstructed line for tax extraction. Returns a hash of collected values.
      # @param line [Mindee::Parsing::Common::Ocr::OcrLine] Processed OCR results.
      # @param found_hash [Hash] Hash containing previously found values, if any.
      # @return [Hash]
      def self.extract_vertical_values(line, found_hash)
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
        found_hash
      end

      # Extracts tax data from a vertical reconstructed row.
      # @param ocr_result [Mindee::Parsing::Common::Ocr] OCR raw results
      # @param tax_names [Array<String>] Array of possible names a tax can have
      # @param found_hash [Hash] Hash of currently retrieved values
      def self.extract_vertical(ocr_result, tax_names, found_hash)
        ocr_result.mvision_v1.pages.each_with_index do |page, page_id|
          page.all_words.each do |word|
            next if match_index(word.text, tax_names).nil?

            reconstructed_line = ocr_result.reconstruct_vertically(word.polygon, page_id)
            found_hash['page_id'] = page_id unless found_hash.key?('page_id')
            found_hash['code'] = word.text.strip unless found_hash.key?('code')
            found_hash = extract_vertical_values(reconstructed_line, found_hash)
          end
        end
        found_hash
      end

      # Extracts a single custom type of tax.
      # For the sake of simplicity, this only extracts the first example, unless specifically instructed otherwise.
      # @param ocr_result [Mindee::Parsing::Common::Ocr::Ocr] result of the OCR.
      # @param tax_names [Array<String>] list of all possible names the tax can have.
      # @return [Mindee::Parsing::Standard::TaxField, nil]
      def self.extract_custom_tax(ocr_result, tax_names)
        return nil if ocr_result.is_a?(Mindee::Parsing::Common::Ocr) || tax_names.empty?

        found_hash = extract_horizontal(ocr_result, tax_names)
        # a tax is considered found horizontally if it has a value, otherwise it is vertical
        found_hash = extract_vertical(ocr_result, tax_names, found_hash)

        return if found_hash.empty?

        Mindee::Parsing::Standard::TaxField.new(found_hash,
                                                found_hash.key?('page_id') ? found_hash['page_id'] : nil)
      end
    end
  end
end
