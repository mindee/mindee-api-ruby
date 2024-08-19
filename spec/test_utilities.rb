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
  end
end
