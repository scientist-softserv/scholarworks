# frozen_string_literal: true

# Usage
# bundle exec rake calstate:migrate_stats_work_view['/home/ec2-user/data/work_views.csv']
# This task takes spreadsheet of google analytics download stats with the following format
# Country City  Page  Page Date Hour and Minute
# It will process the following columns
# Country
# City
# Page - path of the work
# Date Hour and Minute

namespace :calstate do
  desc 'Migrate work view stats'
  task :migrate_stats_work_view, %i[source] => [:environment] do |_t, args|

    source = args[:source] or raise 'Must provide path of work view stats.'
    raise 'Could not find file.' unless File.exist?(source)

    # ignore work creation
    #    ["Chrome", "United States", "La Palma", "/concern/theses/new?locale=en", "2.02204E+11", "1", "0"],
    CSV.read(source).each do |row|
      page_arr = row[3].split('/')
      #p "page_arr [#{page_arr.inspect}]"
      work_id = page_arr.length > 3 ? page_arr[3] : nil
      next if work_id.nil? || work_id.start_with?('new')

      work_id = (page_arr[3].include? '?') ? page_arr[3].partition('?').first : page_arr[3]
      #p "work_id = [#{work_id}] page_arr #{page_arr.inspect}"
      begin
        Hyrax::WorkQueryService.new(id: work_id).work
      rescue Exception => e
        p "Ignore record with #{work_id} since we can not find a work associated with it"
        next
      end

      work_id = (page_arr[3].include? '?') ? page_arr[3].partition('?').first : page_arr[3]
      country = (row[1].nil? || row[1].eql?('(not set)')) ? '' : row[1]
      city = (row[2].nil? || row[2].eql?('(not set)')) ? '' : row[2]

      #p "country [#{country}] city [#{city}] work_id [#{work_id}] time [#{row[4]}] "
      stats_work_view = StatsWorkView.new(work_id: work_id, country: country, city: city, created_at: row[7])
      stats_work_view.save!
    end
  end
end
