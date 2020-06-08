module Hyrax
  module Actors
    class GlacierActor < Hyrax::Actors::AbstractActor
      def create(env)
        uploaded_file_ids = filter_file_ids(env.attributes.delete(:uploaded_files))
        files = uploaded_files(uploaded_file_ids)
        upload_files(files, env) && next_actor.create(env)
      end

      def update(env)
        uploaded_file_ids = filter_file_ids(env.attributes.delete(:uploaded_files))
        files = uploaded_files(uploaded_file_ids)
        upload_files(file, env) && next_actor.update(env)
      end

      private

        def filter_file_ids(input)
          Array.wrap(input).select(&:present?)
        end

        def upload_files(files, env)
          return true if files.blank?

          byebug

          files.each do |file|
            GlacierUploadService.upload(actor.file_set)
          end
        end

        # Fetch uploaded_files from the database
        def uploaded_files(uploaded_file_ids)
          return [] if uploaded_file_ids.empty?
          UploadedFile.find(uploaded_file_ids)
        end
    end
  end
end
