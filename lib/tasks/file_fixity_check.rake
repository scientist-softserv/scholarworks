# frozen_string_literal: true

# Usage
# bundle exec rake calstate:file_fixity_check['abcdefghi']
# bundle exec rake calstate:all_files_fixity_check
#

# this method is adapted from Hyrax::FileSetFixityCheckService
def file_set_fixity_check(file_set_id)
  files = FileSet.find(file_set_id).files

  files.each do |file|
    versions = file.has_versions? ? file.versions.all : [file]
    versions.collect do |v|
      FixityCheckJob.perform_now(v.uri.to_s, file_set_id: file_set_id, file_id: file.id)
    end.flatten
  end

  puts '**********************************************'
  puts "COMPLETED THE FIXITY CHECK FOR FILESET: #{file_set_id}"
end

namespace :calstate do
  desc 'Run a fixity check on a single file'
  task :file_fixity_check, [:file_set_id] => [:environment] do |_t, args|
    file_set_fixity_check(args[:file_set_id])
  end

  desc 'Run a fixity check on all files'
  task all_files_fixity_check: :environment do
    FileSet.all.map { |file_set| file_set_fixity_check(file_set.id) }
  end
end
