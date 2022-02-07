# frozen_string_literal: true

# Usage
# bundle exec rake calstate:file_attach[000000000,/home/ec2-user/data/import/file.pdf]

namespace :calstate do
  desc 'Attach a file to an existing record'
  task :file_attach, %i[id file] => [:environment] do |_t, args|
    id = args[:id]
    filename = args[:file]

    file = File.open(filename)
    uploaded_file = Hyrax::UploadedFile.create(file: file)
    uploaded_file.save

    work = ActiveFedora::Base.find(id)
    depositor = User.find_by(email: 'kcloud@calstate.edu')
    work.apply_depositor_metadata(depositor.user_key)

    AttachFilesToWorkJob.perform_now(work, [uploaded_file])
  end
end
