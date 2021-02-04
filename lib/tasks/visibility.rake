# frozen_string_literal: true

require 'calstate/visibility'

# Usage
# bundle exec rake calstate:visibility[/path/to/file.csv,thesis]
#
# input file should have three columns with headers for:
#   id, work_visibility, file_visibility
# use internal visibility name, e.g.: 'open' instead of 'public'

namespace :calstate do
  desc 'Update visibility of all attached files to work'
  task :visibility, %i[input_file update model_type] => [:environment] do |_t, args|
    input_file = args[:input_file] or raise 'No input file provided.'
    model_type = args[:model_type] ||= 'thesis'

    viz = CalState::Visibility.new
    model = CalState::Metadata.get_model_from_slug(model_type)
    x = 0

    viz.get_csv(input_file).each do |row|
      x += 1
      puts "Processing work ID #{row['id']}"
      model.where(id: row['id']).each do |work|
        viz.set_visibility(work, row['work_visibility'], row['file_visibility'])
        if (x % 5).zero?
          puts 'shhhh sleeping . . . . '
          sleep(180)
        end
      end
    end
  end
end
