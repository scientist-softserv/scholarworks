# frozen_string_literal: true

# Usage
# bundle exec rake calstate:migrate_stats_file_download['/home/ec2-user/data/downloads.csv']
# This task takes spreadsheet of google analytics download stats with the following format
# Country City  Page  Page Title  Event Category  Event Action  Event Label Date Hour and Minute
# It will process the following columns
# Country
# City
# Page - path of the work where the download file attached to and obtain the work ID
# Event Label - file ID
# Date Hour and Minute
namespace :calstate do
  desc 'Migrate file downloads stats'
  task :migrate_stats_file_download, %i[source] => [:environment] do |_t, args|
    source = args[:source] or raise 'Must provide path to file of downloads stats.'
    raise 'Could not find file.' unless File.exist?(source)

    # ignore these kinds of records
    #    ["United States", "Los Angeles", "/concern/parent/jw827g023/file_sets/r494vp416", "Clinicians' perceptions of clinical factors associated with excessive Internet use | ScholarWorks", "Files", "Downloaded", "175", "2.02204E+11", "0", "0", "0", "1", "0"],
    #    ["United States", "La Palma", "/concern/theses/new?locale=en", "Clinicians' perceptions of clinical factors associated with excessive Internet use | ScholarWorks", "Files", "Downloaded", "175", "2.02204E+11", "0", "0", "0", "1", "0"],
    #    ["United States", "empty", "/advanced?f%5Bhas_model_ssim%5D%5B%5D=Publication&locale=en", "Clinicians' perceptions of clinical factors associated with excessive Internet use | ScholarWorks", "Files", "Downloaded", "175", "2.02204E+11", "0", "0", "0", "1", "0"]

    CSV.read(source).each do |row|
      page_arr = row[2].split('/')
      #p "page_arr [#{page_arr.inspect}]"
      work_id = page_arr.length > 3 ? page_arr[3] : nil
      next if work_id.nil? || work_id.start_with?('new') || row[6].eql?('(not set)')

      work_id = (page_arr[3].include? '?') ? page_arr[3].partition('?').first : page_arr[3]

      #p "work_id = [#{work_id}] page_arr #{page_arr.inspect}"
      #page_arr = ["", "concern", "presentations", "nz805z68q?locale=en"]
      begin
        Hyrax::WorkQueryService.new(id: work_id).work
      rescue Exception => e
        p "Ignore record with #{work_id} since we can not find a work associated with it"
        next
      end

      work_id = (page_arr[3].include? '?') ? page_arr[3].partition('?').first : page_arr[3]
      country = (row[0].nil? || row[0].eql?('(not set)')) ? '' : row[0]
      city = (row[1].nil? || row[1].eql?('(not set)')) ? '' : row[1]

      #p "country [#{country}] city [#{city}] work_id [#{work_id}] file_id [#{file_id}] time [#{row[7]}] "
      stats_file_download = StatsFileDownload.new(file_id: file_id, work_id: work_id, country: country, city: city, created_at: row[7])
      stats_file_download.save!
    end
  end
end
