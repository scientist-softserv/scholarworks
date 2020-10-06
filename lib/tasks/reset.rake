# frozen_string_literal: true

require 'calstate/metadata'

namespace :calstate do
  desc 'Delete all records for a specified campus'
  task :reset, %i[campus] => [:environment] do |_t, args|
    # campus name
    campus_id = args[:campus] or raise 'No campus provided.'
    campus_name = Hyrax::CampusService.get_campus_name_from_id(campus_id)

    CalState::Metadata.models.each do |model|
      model.where(campus: campus_name).each.each do |doc|
        title = doc.title.first.to_s
        campus = doc.campus.first.to_s
        puts campus + ': ' + title
        doc.destroy
      end
    end
  end
end
