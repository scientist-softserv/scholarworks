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

    campus_name = Hyrax::CampusService.get_campus_name_from_id(campus)
    query = record == 'all' ? { campus: campus_name } : { id: record }

    x = 0

    CalState::Metadata.models.each do |model|
      model.where(query).each do |work|
        next if work.edit_groups.include? 'managers-' + campus

        x += 1

        # throttle
        if (x % 10).zero?
          puts '    sleeping . . . '
          sleep(60)
        end

        puts "Updating work #{work.id}"

        begin
          work = CalState::Packager.add_manager_group(work, campus)
          work.save
        rescue ActiveFedora::ConstraintError => e
          puts 'ERROR: ' + e.message
        end
      end
    end
  end
end
