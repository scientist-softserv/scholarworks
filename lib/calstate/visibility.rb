# frozen_string_literal: true

module CalState
  #
  # Set visibility on works and files
  #
  class Visibility
    #
    # New Visibility object
    #
    def initialize
      @visibility_options = check_visibility
    end

    #
    # Set visibility on work and files
    #
    # @param work [ActiveFedora::Base]   Fedora work
    # @param work_visibility [String]    visibility for work
    # @param file_visibility [String]    visibility for file
    #
    # @return [FalseClass]
    #
    def set_visibility(work, work_visibility, file_visibility)
      # this is ugly, but couldn't find a more efficient way to do this,
      # especially for campus visibility which behaves differently

      if work_visibility != file_visibility
        # set work to file visibility so files can inherit from that
        work.visibility = file_visibility
        work.save
        InheritPermissionsJob.perform_now(work)

        # then set work to work visibility
        work.visibility = work_visibility
        work.save
      else
        work.visibility = work_visibility
        work.save
        InheritPermissionsJob.perform_now(work)
      end
    end

    #
    # Load input spreadsheet and verify visibility settings
    #
    # @param file [String]  path to csv file
    #
    # @return [Array]
    #
    def get_csv(file)
      x = 0
      rows = []
      csv = CSV.read(file, headers: true)
      csv.each do |row|
        x += 1
        raise csv_error(file, x, 'lacks ID.') if row['id'].empty?

        [row['work_visibility'], row['file_visibility']].each do |visibility|
          unless @visibility_options.include? visibility
            raise csv_error(file, x, 'invalid visibility option: ' + visibility)
          end
        end

        rows << row
      end
      rows
    end

    private

    #
    # Throw CSV error
    #
    # @param file [String]     file name
    # @param row [Integer]     row number
    # @param message [String]  error message
    #
    def csv_error(file, row, message)
      raise 'Row ' + row.to_s + ' of ' + file + ' contains ' + message
    end

    #
    # Get the visibility option from AccessControls
    #
    # @return [Array]
    #
    def check_visibility
      options = []
      Hydra::AccessControls::AccessRight.constants(false).each do |c|
        if c.to_s.include? 'VISIBILITY'
          options.append Hydra::AccessControls::AccessRight.const_get c
        end
      end
      options
    end
  end
end
