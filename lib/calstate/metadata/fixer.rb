# frozen_string_literal: true

module CalState
  module Metadata
    #
    # Fix metadata problems
    #
    module Fixer
      #
      # Attach file to work
      #
      # @param work [ActiveFedora::Base]  the work
      # @param user_key [String]          the user key (email)
      # @param file_path [String]         the path to the file to upload
      #
      def attach_file(work, user_key, file_path)
        depositor = User.find_by_user_key(user_key)
        work.apply_depositor_metadata(depositor.user_key)
        file = File.open(file_path)
        uploaded_file = Hyrax::UploadedFile.create(file: file)
        AttachFilesToWorkJob.perform_now(work, [uploaded_file])
      end

      #
      # Find any records that are missing campus name and add it
      #
      def add_missing_campus
        CalState::Metadata.models.each do |model|
          model.where(campus: nil).each do |doc|
            admin_set = doc.admin_set.title.first.to_s
            CampusService.get_campus_from_admin_set(admin_set)
            doc.campus = [campus]
            doc.save
          end
        end
      end
    end
  end
end
