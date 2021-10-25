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
  task :visibility, %i[input_file] => [:environment] do |_t, args|
    input_file = args[:input_file] or raise 'No input file provided.'

    viz = CalState::Visibility.new
    x = 0

    viz.get_csv(input_file).each do |row|
      x += 1
      print "Processing work #{row['id']} . . . "

      begin
        work = ActiveFedora::Base.find(row['id'])
        viz.set_visibility(work, row['work_visibility'], row['file_visibility'])
      rescue Ldp::Gone
        print '[ GONE! ] . . . '
      rescue ActiveFedora::ObjectNotFoundError
        print '[ NOT FOUND! ] . . . '
      end

      print "done!\n"

      if (x % 5).zero?
        puts 'shhhh sleeping . . . . '
        sleep(180)
      end
    end
  end
end
