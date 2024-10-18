# frozen_string_literal: true

require_relative 'ocr_extractor'

module Mindee
  module Extraction
    # Tax extractor class
    class TaxExtractor < OcrExtractor
      # Extracts the most relevant candidate.
      # @param candidates [Array<Hash>] a candidate for the tax.
      # @param tax_names [Array<String>] list of all possible names the tax can have.
      # @return [Hash, nil]
      def self.pick_best(candidates, tax_names)
        return candidates[0] if candidates.size == 1
        return nil if candidates.empty?

        picked = 0
        picked_score = 0

        candidates.each_with_index do |candidate, i|
          next unless valid_candidate?(candidate, tax_names)

          sum_fields_score = calculate_score(candidate, i)

          if picked_score < sum_fields_score
            picked_score = sum_fields_score
            picked = i
          end
        end

        candidates[picked]
      end

      # Checks whether a tax code has been properly read. Shouldn't trigger except in case of very specific regex breaks
      # due to unsupported diacritics.
      # @param candidate [Hash] A candidate for the tax.
      # @param tax_names [Array<String>] list of all possible names the tax can have.
      # @return [Boolean]
      def self.valid_candidate?(candidate, tax_names)
        return false if tax_names.empty? || candidate.nil? || candidate['code'].nil?

        tax_names.each do |tax_name|
          return true if remove_accents(tax_name.downcase) == remove_accents(candidate['code'].downcase)
        end
        false
      end

      # [Experimental] computes the score of a valid candidate for a tax.
      # @param candidate [Hash] A candidate for the tax.
      # @param index [Integer]
      def self.calculate_score(candidate, index)
        score = index + 1
        unless candidate['rate'].nil?
          score += 1
          score -= 2 if candidate['rate'] > 100
          score -= 1 if candidate['rate'] > 30
        end
        score += 4 unless candidate['value'].nil?
        score += 1 unless candidate['base'].nil?
        score
      end

      # Curates tax values based on simple rules to avoid improbable data
      # @param found_hash [Hash] Hash of currently retrieved values
      # @param min_rate_percentage [Integer] Minimum allowed rate on the tax.
      # @param max_rate_percentage [Integer] Maximum allowed rate on the tax.
      # @return [Hash]
      def self.curate_values(found_hash, min_rate_percentage, max_rate_percentage)
        reconstructed_hash = { 'code' => nil, 'page_id' => nil, 'rate' => nil, 'base' => nil, 'value' => nil }
        return reconstructed_hash if found_hash.nil?

        reconstructed_hash['code'] =
          found_hash['code'].nil? ? found_hash['code'] : found_hash['code'].sub(%r{\s*\.*\s*$}, '')

        if found_hash['rate'] && found_hash['rate'] < 1 && (found_hash['rate']).positive?
          found_hash['rate'] =
            found_hash['rate'] * 100
        end
        found_hash = swap_rates_if_needed(found_hash, min_rate_percentage, max_rate_percentage)
        found_hash = decimate_rates_if_needed(found_hash)
        found_hash = fix_rate(found_hash)
        reconstructed_hash['rate'] = found_hash['rate']
        set_base_and_value(reconstructed_hash, found_hash)
      end

      # Swaps the rate with base or value if rate is out of bounds
      # @param found_hash [Hash] Hash of currently retrieved values
      # @param min_rate_percentage [Integer] Minimum allowed rate on the tax.
      # @param max_rate_percentage [Integer] Maximum allowed rate on the tax.
      # @return [Hash]
      def self.swap_rates_if_needed(found_hash, min_rate_percentage, max_rate_percentage)
        if found_hash['rate'] && (found_hash['rate'] > max_rate_percentage || found_hash['rate'] < min_rate_percentage)
          if valid_percentage?(found_hash['base'], min_rate_percentage, max_rate_percentage)
            found_hash['rate'], found_hash['base'] = found_hash['base'], found_hash['rate']
          elsif valid_percentage?(found_hash['value'], min_rate_percentage, max_rate_percentage)
            found_hash['rate'], found_hash['value'] = found_hash['value'], found_hash['rate']
          end
        end
        found_hash
      end

      # Rates can't be negative if set.
      # @param found_hash [Hash] Hash of currently retrieved values
      def self.fix_rate(found_hash)
        found_hash['rate'] = found_hash['rate'].abs unless found_hash['rate'].nil?
        found_hash
      end

      # Swaps the rate with base or value if rate is out of bounds
      # @param found_hash [Hash] Hash of currently retrieved values
      # @return [Hash]
      def self.decimate_rates_if_needed(found_hash)
        if found_hash['rate'] && found_hash['rate'] > 100
          if !found_hash['base'].nil? && found_hash['rate'] > found_hash['base']
            found_hash['rate'], found_hash['base'] = found_hash['base'], found_hash['rate']
          elsif !found_hash['value'].nil? && found_hash['rate'] > found_hash['value']
            found_hash['rate'], found_hash['value'] = found_hash['value'], found_hash['rate']
          end
        end
        found_hash
      end

      # Sets the base and value in the reconstructed hash based on certain conditions
      # @param reconstructed_hash [Hash] Hash being reconstructed with new values
      # @param found_hash [Hash] Hash of currently retrieved values
      # @return [Hash]
      def self.set_base_and_value(reconstructed_hash, found_hash)
        if found_hash['base'].nil?
          reconstructed_hash['base'] = found_hash['base']
          reconstructed_hash['value'] = found_hash['value']
        elsif found_hash['value'].nil? && found_hash['base'] < found_hash['value']
          reconstructed_hash['base'] = found_hash['value']
          reconstructed_hash['value'] = found_hash['base']
        else
          reconstructed_hash['value'] = found_hash['value']
        end
        reconstructed_hash
      end

      # Extracts a single custom type of tax.
      # For the sake of simplicity, this only extracts the first example, unless specifically instructed otherwise.
      # @param ocr_result [Mindee::Parsing::Common::Ocr::Ocr] result of the OCR.
      # @param tax_names [Array<String>] list of all possible names the tax can have.
      # @param min_rate_percentage [Integer] Minimum allowed rate on the tax.
      # @param max_rate_percentage [Integer] Maximum allowed rate on the tax.
      # @return [Mindee::Parsing::Standard::TaxField, nil]
      def self.extract_custom_tax(ocr_result, tax_names, min_rate_percentage = 0, max_rate_percentage = 100)
        return nil if ocr_result.is_a?(Mindee::Parsing::Common::Ocr) || tax_names.empty?

        tax_names.sort!
        found_hash = pick_best(extract_horizontal_tax(ocr_result, tax_names), tax_names)
        # a tax is considered found horizontally if it has a value, otherwise it is vertical
        if found_hash.nil? || found_hash['value'].nil?
          found_hash = extract_vertical_tax(ocr_result, tax_names,
                                            found_hash)
        end
        found_hash = curate_values(found_hash, min_rate_percentage, max_rate_percentage)

        return if found_hash.nil? || found_hash.empty?

        create_tax_field(found_hash)
      end

      # Creates a tax field from a given hash.
      # @param found_hash [Hash] Hash of currently retrieved values
      # @return [Mindee::Parsing::Standard::TaxField]
      def self.create_tax_field(found_hash)
        Mindee::Parsing::Standard::TaxField.new(
          found_hash,
          found_hash.key?('page_id') ? found_hash['page_id'] : nil
        )
      end

      # Extracts the rate and code, if found, from matches into the found_hash.
      # @param matches [MatchData] RegEx matches of the values for taxes
      # @param found_hash [Hash] Hash of currently retrieved values
      # @param percent_first [Boolean] Whether the percentage was found before or after the tax name.
      # @return [Hash]
      def self.extract_percentage_from_tax(matches, found_hash, percent_first)
        if percent_first
          found_hash['code'] = matches[2].strip unless matches[2].nil?
          found_hash['rate'] = parse_amount(matches[1].gsub('%', '')) unless matches[1].nil?
        else
          found_hash['code'] = matches[1].strip unless matches[1].nil?
          found_hash['rate'] = parse_amount(matches[2].gsub('%', '')) unless matches[2].nil?
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
          found_hash['base'] = parse_amount(matches[3]) unless matches[3].nil?
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
      def self.extract_tax_from_horizontal_line(line, pattern, page_id, percent_first)
        found_hash = {}

        matches = line.match(pattern)

        # Edge case for when the tax is split-up between two pages, we'll consider that
        # the answer belongs to the first one.
        found_hash['page_id'] = page_id unless found_hash.key?('page_id')
        return found_hash if matches.nil?

        found_hash = extract_percentage_from_tax(matches, found_hash, percent_first)
        extract_basis_and_value(matches, found_hash)
      end

      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity

      # Processes a horizontal line for tax extraction. Returns a hash of collected values.
      # @param ocr_result [Mindee::Parsing::Common::Ocr::Ocr] Processed OCR results.
      # @param tax_names [Array<String>] Possible tax names candidates.
      # @return [Array<Hash>]
      def self.extract_horizontal_tax(ocr_result, tax_names)
        candidates = [{ 'code' => nil, 'value' => nil, 'base' => nil, 'rate' => nil }]
        linear_pattern_percent_first = %r{
          ((?:\s*-\s*)?(?:\d*[.,])*\d+[ ]?%?|%?[ ]?(?:\s*-\s*)?(?:\d*[.,])*\d+)?[ .]?
          ([a-zA-ZÀ-ÖØ-öø-ÿ .]*[a-zA-ZÀ-ÖØ-öø-ÿ]?)[ .]?
          ((?:\s*-\s*)?(?:\d*[.,])+\d{2,})?[ .]*
          ((?:\s*-\s*)?(\d*[.,])*\d{2,})?
        }x
        linear_pattern_percent_second = %r{
          ([a-zA-ZÀ-ÖØ-öø-ÿ .]*[a-zA-ZÀ-ÖØ-öø-ÿ]?)[ .]*
          ((?:\s*-\s*)?(?:\d*[.,])*\d+[ ]?%?|%?[ ]?(?:\s*-\s*)?(?:\d*[.,])*\d+)?[ .]?
          ((?:\s*-\s*)?(?:\d*[.,])+\d{2,})?[ .]*
          ((?:\s*-\s*)?(\d*[.,])*\d{2,})?
        }x
        ocr_result.mvision_v1.pages.each.with_index do |page, page_id|
          page.all_lines.each do |line|
            clean_line = remove_currency_symbols(line.to_s.scrub.gsub(%r{[+(\[)\]¿?*_]}, '')).gsub(%r{\.{2,}}, ' ')
                                                                                             .gsub(%r{ +}, ' ').strip

            next if match_index(clean_line, tax_names).nil?

            unless clean_line.match(linear_pattern_percent_second).nil?
              candidates.append(extract_tax_from_horizontal_line(clean_line[match_index(clean_line, tax_names)..],
                                                                 linear_pattern_percent_second, page_id, false))
            end
            if clean_line.include?('%') && !clean_line.match(linear_pattern_percent_first).nil?
              candidates.append(extract_tax_from_horizontal_line(clean_line[clean_line.index(%r{\d*[.,]?\d* ?%})..],
                                                                 linear_pattern_percent_first, page_id, true))
            elsif !clean_line.match(linear_pattern_percent_first).nil?
              candidates.append(extract_tax_from_horizontal_line(clean_line,
                                                                 linear_pattern_percent_first, page_id, true))
            end
          end
        end
        candidates
      end

      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      # Processes a vertical reconstructed line for tax extraction. Returns a hash of collected values.
      # @param line [Mindee::Parsing::Common::Ocr::OcrLine] Processed OCR results.
      # @param found_hash [Hash] Hash containing previously found values, if any.
      # @return [Hash]
      def self.extract_vertical_tax_values(line, found_hash)
        amounts = []
        line.each do |reconstructed_word|
          amounts.push(parse_amount(reconstructed_word.text)) unless parse_amount(reconstructed_word.text).nil?
        end
        if amounts.length == 1 && !found_hash.key?('value')
          found_hash['value'] = amounts[0]
        else
          found_hash['rate'] = amounts[0] if found_hash['rate'].nil?
          found_hash['value'] = amounts[1] if found_hash['value'].nil?
        end
        found_hash
      end

      # Extracts tax data from a vertical reconstructed row.
      # @param ocr_result [Mindee::Parsing::Common::Ocr] OCR raw results
      # @param tax_names [Array<String>] Array of possible names a tax can have
      # @param found_hash [Hash] Hash of currently retrieved values
      def self.extract_vertical_tax(ocr_result, tax_names, found_hash)
        found_hash = { 'code' => nil, 'page_id' => nil } if found_hash.nil?

        ocr_result.mvision_v1.pages.each_with_index do |page, page_id|
          page.all_words.each do |word|
            next if match_index(word.text, tax_names).nil?

            reconstructed_line = ocr_result.reconstruct_vertically(word.polygon, page_id)
            found_hash['page_id'] = page_id if found_hash['page_id'].nil?
            found_hash['code'] = word.text.strip if found_hash['code'].nil?
            found_hash = extract_vertical_tax_values(reconstructed_line, found_hash)
          end
        end
        found_hash
      end

      private_class_method :extract_percentage_from_tax, :extract_basis_and_value, :extract_tax_from_horizontal_line,
                           :extract_horizontal_tax, :extract_vertical_tax_values, :extract_vertical_tax,
                           :create_tax_field, :fix_rate, :pick_best, :calculate_score, :curate_values,
                           :decimate_rates_if_needed, :extract_basis_and_value, :set_base_and_value, :valid_candidate?,
                           :swap_rates_if_needed
    end
  end
end
