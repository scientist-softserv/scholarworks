# frozen_string_literal: true

# Usage
# bundle exec rake calstate:update_managers[losangeles]
# bundle exec rake calstate:update_managers[sacramento,6d56zz11h]

namespace :calstate do
  desc 'Update managers to work'
  task :update_managers, %i[campus record] => [:environment] do |_t, args|
    campus = args[:campus] or raise 'No campus provided'
    record = args[:record] ||= 'all'

    campus_name = Hyrax::CampusService.get_campus_name_from_id(campus)
    query = record == 'all' ? { campus: campus_name } : { id: record }

    CalState::Metadata.models.each do |model|
      model.where(query).each do |work|
        admin_set_id = work.admin_set_id
        puts "Updating work #{work.id} in adminset #{admin_set_id}"
        work = add_managers(work, admin_set_id)
        work.save
      end
    end
  end
end
