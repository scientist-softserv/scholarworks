# frozen_string_literal: true

require 'calstate/metadata'

# Usage
# bundle exec rake calstate:characterize[northridge]
# bundle exec rake calstate:characterize[northridge,abc123456]
# bundle exec rake calstate:characterize['id:abc123456']

namespace :calstate do
  desc 'Rerun characterize on a work or campus.'
  task :characterize, %i[campus skip_to] => [:environment] do |_t, args|
    campus = args[:campus] or raise 'Must provide campus name or id.'
    skip_to = (args[:skip_to] or nil)
    skip = true

    # work supplied
    if campus.include?('id:') && campus.length > 4
      work = ActiveFedora::Base.find(campus[3..])
      run_characterize(work)
    else
      # campus supplied
      campus_name = CampusService.get_name_from_slug(campus)

      # solr reader is faster than built-in models, especially when skipping
      solr = CalState::Metadata::Solr::Reader.new(campus: campus_name)
      solr.records.each do |record|
        # skip to specific record if told to do so
        unless skip_to.nil?
          skip = false if record.get('id') == skip_to
          next if skip
        end

        # now fetch actual work and run characterization
        work = ActiveFedora::Base.find(record.get('id'))
        run_characterize(work)
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
