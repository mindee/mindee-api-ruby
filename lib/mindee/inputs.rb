# frozen_string_literal: true

require 'origami'

module PDFTools
  def to_bin_str(params = {})
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

    output options
  end

  def to_base64(params = {})
    [to_bin_str(params)].pack('m')
  end
end

Origami::PDF.class_eval { include PDFTools }

module Mindee
  class InputDocument
    attr_reader :file_object,
                :filename,
                :filepath

    def initialize(cut_pdf, n_pdf_pages)
      merge_pdf_pages n_pdf_pages if cut_pdf && @file_object.pages.size > 3
    end

    def merge_pdf_pages(n_pdf_pages)
      new_pdf = Origami::PDF.new

      @file_object.pages[0, n_pdf_pages].each_with_index do |page, idx|
        new_pdf.insert_page(idx, page)
      end
      @file_object = new_pdf
    end
  end

  class PathDocument < InputDocument
    def initialize(filepath, cut_pdf, n_pdf_pages: 3)
      puts "opening #{filepath}"
      @file_object = Origami::PDF.read filepath
      @filepath = filepath
      super(cut_pdf, n_pdf_pages)
    end
  end

  class Base64Document < InputDocument
    def initialize(base64_string, filename, cut_pdf, n_pdf_pages: 3)
      puts "loading #{base64_string} #{filename}"
      @file_object = Origami::PDF.read filepath
      @filename = filename
      super(cut_pdf, n_pdf_pages)
    end
  end
end
