#
# OVERRIDE class from hydra-derivatives v3.7.0
#
require_relative '../processors/pdf_processor'

module Hydra
  module Derivatives
    class PdfDerivatives < ImageDerivatives
      # def self.processor_class
      #   Processors::PdfProcessor
      # end
    end
  end
end
