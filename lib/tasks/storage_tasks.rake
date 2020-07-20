class GlacierStorageJob < ActiveJob::Base
  def perform(file_set_id) 
    file_set = FileSet.find(file_set_id)
    GlacierUploadService.upload(file_set)
  end
end

namespace :storage do
  desc "Send all FileSets to glacier if not set"
  task glaicer_backfill: :environment do
    FileSet.all.each do |file_set|
      next if file_set.glacier_location
      GlacierStorageJob.perform_later(file_set.id)
    end
  end
end
