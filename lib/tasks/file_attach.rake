# frozen_string_literal: true

# Usage
# bundle exec rake calstate:file_attach[000000000,/home/ec2-user/data/import/file.pdf,admin@calstate.edu]
# bundle exec rake calstate:file_attach[012345678,s3://bucket/path/file.pdf,admin@calstate.edu]
#
namespace :calstate do
  desc 'Attach a file to an existing record'
  task :file_attach, %i[id file depositor] => [:environment] do |_t, args|
    id = args[:id]
    filename = args[:file]
    email = args[:depositor]
    is_s3 = false

    # we supplied an s3 file path, so download file first
    if filename.include?('s3://')
      is_s3 = true
      filename.gsub!('s3://', '')
      file_parts = filename.split('/')
      bucket = file_parts.shift
      raise "Your s3_path `#{filename}` appears to be malformed." if bucket.nil?
      remote_file = file_parts.join('/')
      filename = '/home/ec2-user/data/import/' + remote_file
      Aws::S3::Resource.new.bucket(bucket).object(remote_file).download_file(filename)
    end

    # make sure we have a work
    work = ActiveFedora::Base.find(id)
    file_visibility = work.file_sets.first.visibility
    work_visibility = work.visibility

    # get file
    file = File.open(filename)

    # create new upload
    uploaded_file = Hyrax::UploadedFile.create(file: file)
    uploaded_file.save

    # attach!
    depositor = User.find_by_user_key(email)
    work.apply_depositor_metadata(depositor.user_key)
    AttachFilesToWorkJob.perform_now(work, [uploaded_file])

    # work & files have different visibility, so likely a campus visibility sitch
    if work_visibility != file_visibility
      CalState::Packager.update_visibility(work, work_visibility, file_visibility)
    end

    # remove downloaded s3 file
    File.delete(filename) if is_s3 && File.exists?(filename)
  end
end
