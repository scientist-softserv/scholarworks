# frozen_string_literal: true

require 'csv'
require 'calstate/metadata'

module CalState
  #
  # Importer
  #
  class Importer
    include CalState::Metadata::Csv::Utilities

    #
    # New Importer
    #
    # @param csv_file [String]  path to csv file
    #
    def attach_all(csv_file)
      file_dir = file_dir(csv_file)
      viz = CalState::Visibility.new

      load_csv(csv_file).each do |record|
        work = ActiveFedora::Base.find(record['id'])
        file = record['file']

        puts record['id']

        # remove existing files
        unless record['replace'].nil?
          remove_files(work)
          file = record['replace']
        end

        # attach new files
        file.split('|').each do |file|
          attach_file_to_work(work, file_dir + '/' + file)
        end

        # set visibility
        unless record['work_visibility'].empty? && record['file_visibility'].empty?
          viz.set_visibility(work, record['work_visibility'], record['file_visibility'])
        end

        print "\n\n"
      end
    end

    #
    # Load csv file
    #
    # @param csv_file [String]  path to csv file
    #
    # @return [Array]
    #
    def load_csv(csv_file)
      options = { headers: true, encoding: 'bom|utf-8' }
      csv = CSV.read(csv_file, options)
      load_records(csv)
    end

    #
    # Extract file dir from csv file path
    #
    # @param csv_file [String]  file path
    #
    def file_dir(csv_file)
      file_dir = csv_file.split('/')
      file_dir.pop
      file_dir.join('/')
    end

    #
    # Remove all file_sets from a work
    #
    # @param work [ActiveFedora::Base]
    #
    def remove_files(work)
      work.file_sets.each(&:destroy!)
    end

    #
    # Attach a file to a work
    #
    # @param work [ActiveFedora::Base|String]  work or work id
    # @param filename [String]                 path to file
    #
    def attach_file_to_work(work, filename)
      # make sure we have a work
      work = ActiveFedora::Base.find(work) if work.is_a?(String)

      # create new file
      file = File.open(filename)
      uploaded_file = Hyrax::UploadedFile.create(file: file)
      uploaded_file.save

      # attach!
      depositor = User.find_by(email: 'kcloud@calstate.edu')
      work.apply_depositor_metadata(depositor.user_key)
      AttachFilesToWorkJob.perform_now(work, [uploaded_file])
    end
  end
end
