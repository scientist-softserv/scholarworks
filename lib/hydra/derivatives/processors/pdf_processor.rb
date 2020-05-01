require 'mini_magick'

module Hydra
  module Derivatives
    module Processors
      class PdfProcessor < Processor
        class_attribute :timeout

        def process
          timeout ? process_with_timeout : create_resized_image
        end

        def process_with_timeout
          Timeout.timeout(timeout) { create_resized_image }
        rescue Timeout::Error
          raise Hydra::Derivatives::TimeoutError, "Unable to process image derivative\nThe command took longer than #{timeout} seconds to execute"
        end

        protected

          # When resizing images, it is necessary to flatten any layers, otherwise the background
          # may be completely black. This happens especially with PDFs. See #110
          def create_resized_image
            create_image do |xfrm|
              if size
                xfrm.flatten
                xfrm.resize(size.to_f)
              end
            end
          end

          def create_image
            xfrm = load_and_select_layer
            yield(xfrm) if block_given?
            xfrm.quality(quality.to_s) if quality
            write_image(xfrm)
          end

          def write_image(xfrm)
            output_io = StringIO.new
            q = quality ? quality : 100
            format = directives.fetch(:format)
            output_io.puts xfrm.write_to_buffer ".#{format}", {Q: q}
            output_io.rewind
            output_file_service.call(output_io, directives)
          end

        private

          def size
            directives.fetch(:size, nil)
          end

          def quality
            directives.fetch(:quality, nil)
          end

          def load_and_select_layer
            Vips::Image.new_from_file source_path, page: directives.fetch(:layer, 0)
            #Vips::Image.pdfload(source_path, page: directives.fetch(:layer, 0))
          end
      end
    end
  end
end
