# frozen_string_literal: true

require 'calstate/packager'

# Usage
# bundle exec rake calstate:managers[losangeles]
# bundle exec rake calstate:managers[sacramento,6d56zz11h]

namespace :calstate do
  desc 'Update managers to work'
  task :managers, %i[campus record] => [:environment] do |_t, args|
    # error check
    campus = args[:campus] or raise 'No campus provided'
    record = args[:record] ||= 'all'

    if record == 'all'
      campus_name = CampusService.get_name_from_slug(campus)
      CalState::Metadata.models.each do |model|
        model.where(campus: campus_name).each do |work|
          puts "Updating work #{work.id}"
          begin
            CalState::Packager.add_manager_group_to_work(work, campus)
          rescue ActiveFedora::ConstraintError => e
            puts 'ERROR: ' + e.message
          end
        end
      end
    else
      work = ActiveFedora::Base.find(record)
      puts "Updating work #{work.id}"
      CalState::Packager.add_manager_group_to_work(work, campus)
    end
  end
end
