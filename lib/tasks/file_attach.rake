# frozen_string_literal: true

require 'calstate/importer'

# Usage
# bundle exec rake calstate:file_attach[000000000,/home/ec2-user/data/import/file.pdf]
# bundle exec rake calstate:file_attach[all,/home/ec2-user/data/foo/bar.csv]

namespace :calstate do
  desc 'Attach a file to an existing record'
  task :file_attach, %i[id file] => [:environment] do |_t, args|
    id = args[:id]
    file = args[:file]

    importer = CalState::Importer.new

    if id == 'all'
      importer.attach_all(file)
    else
      importer.attach_file_to_work(id, file)
    end
  end
end
