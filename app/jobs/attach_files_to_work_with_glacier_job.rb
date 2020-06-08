class AttachFilesToWorkWithGlacierJob < AttachFilesToWorkJob
  def perform(work, uploaded_files, **work_attributes)
    validate_files!(uploaded_files)
    depositor = proxy_or_depositor(work)
    user = User.find_by_user_key(depositor)
    work_permissions = work.permissions.map(&:to_hash)
    metadata = visibility_attributes(work_attributes)

    uploaded_files.each do |uploaded_file|
      next if uploaded_file.file_set_uri.present?

      actor = Hyrax::Actors::FileSetActor.new(FileSet.create, user)
      uploaded_file.update(file_set_uri: actor.file_set.uri)
      actor.file_set.permissions_attributes = work_permissions
      actor.create_metadata(metadata)
      actor.create_content(uploaded_file)
      actor.attach_to_work(work)
      GlacierUploadService.upload(actor.file_set)
    end
  end
end
