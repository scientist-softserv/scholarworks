# frozen_string_literal: true

namespace :calstate do
  desc 'Generate report of uploaded files'
  task file_report: :environment do
    Hyrax::UploadedFile.all.each do |uploaded_file|
      wrappers = uploaded_file.job_io_wrappers
      id = uploaded_file.id.to_s

      print "\n" + id + "\t"

      if wrappers.count.zero?
        print '[ MISSING ]'
        next
      end

      uploaded_file.job_io_wrappers.each do |wrapper|
        begin
          file_set = FileSet.find(wrapper.file_set_id)
          work = file_set.parent
          print work.id unless work.nil?
        rescue Ldp::Gone
          print '[ GONE! ]'
        end

        print "\t" + uploaded_file.file.to_s.split('/').pop
      end
    end
  end
end


