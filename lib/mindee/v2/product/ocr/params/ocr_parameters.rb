# frozen_string_literal: true

module Mindee
  module V2
    module Product
      module Ocr
        module Params
          class OcrParameters < Input::BaseParameters
            # Parameters accepted by the ocr utility v2 endpoint.
            class OcrParameters < Mindee::Input::BaseParameters
              @_slug = 'ocr'

              # @param [String] model_id ID of the model
              # @param [String, nil] file_alias File alias, if applicable.
              # @param [Array<String>, nil] webhook_ids List of webhook IDs to propagate the API response to.
              # @param [Hash, nil] polling_options Options for polling. Set only if having timeout issues.
              # @param [Boolean, nil] close_file Whether to close the file after parsing.
              def initialize(
                model_id,
                file_alias: nil,
                webhook_ids: nil,
                polling_options: nil,
                close_file: true
              )
                super
              end

              # Loads the parameters from a Hash.
              # @param [Hash] params Parameters to provide as a hash.
              # @return [OcrParameters]
              def self.from_hash(params: {})
                OcrParameters.new(
                  params.fetch(:model_id),
                  file_alias: params.fetch(:file_alias, nil),
                  webhook_ids: params.fetch(:webhook_ids, nil),
                  close_file: params.fetch(:close_file, true)
                )
              end
            end
          end
        end
      end
    end
  end
end
