# frozen_string_literal: true

require 'calstate/visibility'

# Usage
# bundle exec rake calstate:update_visibility[/path/to/file.csv,file,thesis]
# bundle exec rake calstate:update_visibility[/path/to/file.csv,work,thesis]
#
# work_file is used to indicate either the visibility change applies to the work or file
# model can be either Thesis,Publication,EducationalResource,DataSet.
# We will assume model is Thesis if not entered
# input_file is a csv file like test.csv
# input file consists of two columns, ID and visibility
# where visibility can be "open", "authenticated", or "restricted"
#
namespace :calstate do
  desc 'Update visibility of all attached files to work'
  task :update_visibility, %i[input_file update model_type] => [:environment] do |_t, args|
    input_file = args[:input_file] or raise 'No input file provided.'
    update = args[:update] ||= 'work'
    model_type = args[:model_type] ||= 'thesis'

    viz = CalState::Visibility.new
    model = CalState::Metadata.get_model_from_slug(model_type)
    x = 1

    viz.get_csv(input_file).each do |row|
      x += 1
      puts "Processing work ID #{row['id']}"
      model.where(id: row['id']).each do |work|
        if update == 'work'
          work.visibility = row['work_visibility']
          work.save
        else
          viz.set_file_visibility(work, row['work_visibility'], row['file_visibility'])
          if CalState::Metadata.should_throttle(x, 5)
            puts 'shhhh sleeping . . . . '
            sleep(180)
          end
        end
      end
    end
  end
end
