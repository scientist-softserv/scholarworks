# frozen_string_literal: true

require 'calstate/metadata'

# Usage
# bundle exec rake calstate:thumbnails[northridge]

namespace :calstate do
  desc 'Regenerate thumbnails'
  task :thumbnails, %i[campus] => [:environment] do |_t, args|
    campus = args[:campus] or raise 'Must provide campus name.'
    campus_name = CampusService.get_name_from_slug(campus)

    CalState::Metadata.models.each do |model|
      model.where(campus: campus_name).each do |work|
        puts "#{work.id} (#{work.class.name})"

        fileset = work.file_sets.first
        next if fileset.nil?

        file_id = fileset&.original_file&.id
        next if file_id.nil?

        CharacterizeJob.perform_now(fileset, file_id)
      end
    end
  end
end
