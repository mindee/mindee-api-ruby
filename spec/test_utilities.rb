# frozen_string_literal: true

module Mindee
  # Testing utility module.
  module TestUtilities
    def self.get_version(rst_str)
      version_line_start_pos = rst_str.index(':Product: ')
      version_end_pos = rst_str.index("\n", version_line_start_pos)
      version_start_pos = rst_str[version_line_start_pos..version_end_pos].rindex(' v')
      rst_str[(version_line_start_pos + version_start_pos + 2)...version_end_pos]
    end

    def self.get_id(rst_str)
      id_end_pos = rst_str.index("\n:Filename:")
      id_start_pos = rst_str.index(':Mindee ID: ')
      rst_str[(id_start_pos + 12)...id_end_pos]
    end

    # Implementation of the levenshtein algorithm from here: https://rosettacode.org/wiki/Levenshtein_distance#Ruby
    # Without the downcase operation since we care about case in the return strings.
    # @param [String] ref_string First String.
    # @param [String] target_string Second String.
    # @return [Integer] Levenshtein distance between the strings.
    def self.levenshtein_distance(ref_string, target_string)
      previous_row = Array(0..target_string.length)

      (1..ref_string.length).each do |i|
        current_row = [i]
        previous_diagonal = i - 1

        (1..target_string.length).each do |j|
          insertion_cost = previous_row[j] + 1
          deletion_cost = current_row[j - 1] + 1
          substitution_cost = ref_string[i - 1] == target_string[j - 1] ? previous_diagonal : previous_diagonal + 1

          current_row[j] = [insertion_cost, deletion_cost, substitution_cost].min
          previous_diagonal = previous_row[j]
        end

        previous_row = current_row
      end

      previous_row[target_string.length]
    end

    # Returns the Levenshtein ratio between two provided strings.
    # @param [String] ref_string First String.
    # @param [String] target_string Second String.
    # @return [Float] Levenshtein distance between the strings.
    def self.levenshtein_ratio(ref_string, target_string)
      ref_length = ref_string.length
      target_length = target_string.length
      max_length = [ref_length, target_length].max

      return 1.0 if (ref_length == 0 && target_length == 0) || max_length.nil?

      distance = levenshtein_distance(ref_string, target_string)
      1.0 - (distance.to_f / max_length)
    end
  end
end
