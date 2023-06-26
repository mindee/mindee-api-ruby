# frozen_string_literal: true

module Mindee
  module PDF
    # Monkey-patching for Origami
    module PDFTools
      def to_io_stream(params = {})
        options = {
          delinearize: true,
          recompile: true,
          decrypt: false,
        }
        options.update(params)

        if frozen? # incompatible flags with frozen doc (signed)
          options[:recompile] = nil
          options[:rebuild_xrefs] = nil
          options[:noindent] = nil
          options[:obfuscate] = false
        end
        load_all_objects unless @loaded

        intents_as_pdfa1 if options[:intent] =~ %r{pdf[/-]?A1?/i}
        delinearize! if options[:delinearize] && linearized?
        compile(options) if options[:recompile]

        io_stream = StringIO.new(output(options))
        io_stream.set_encoding Encoding::BINARY
        io_stream
      end
    end
  end
end
