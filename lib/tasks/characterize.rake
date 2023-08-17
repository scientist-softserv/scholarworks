# frozen_string_literal: true

require 'calstate/metadata'

# Usage
# bundle exec rake calstate:characterize[northridge]
# bundle exec rake calstate:characterize['id:abc123456']

namespace :calstate do
  desc 'Rerun characterize on a work or campus.'
  task :characterize, %i[campus] => [:environment] do |_t, args|
    campus = args[:campus] or raise 'Must provide campus name or id.'

    # work supplied
    if campus.include?('id:') && campus.length > 4
      work = ActiveFedora::Base.find(campus[3..])
      run_characterize(work)
    else
      # campus supplied
      campus_name = CampusService.get_name_from_slug(campus)
      CalState::Metadata.models.each do |model|
        model.where(campus: campus_name).each do |work|
          run_characterize(work)
        end
      end
    end
  end

  def run_characterize(work)
    puts "#{work.id} (#{work.class.name})"

    fileset = work.file_sets.first
    return if fileset.nil?

    file_id = fileset&.original_file&.id
    return if file_id.nil?

    CharacterizeJob.perform_now(fileset, file_id)
  end
end
