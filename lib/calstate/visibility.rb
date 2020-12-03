# frozen_string_literal: true

module CalState
  class Visibility
    #
    # New Visibility object
    #
    def initialize
      @visibility_options = check_visibility
    end

    #
    # Set visibility on files
    #
    # @param [ActiveFedora::Base] work   ScholarWorks work
    # @param [String] visibility         visibility option
    #
    # @return [FalseClass]
    #
    def set_file_visibility(work, visibility)
      # this is ugly, but couldn't find a more efficient way to do this,
      # especially for campus visibility which behaves differently
      original_visibility = work.visibility

      # set work to new visibility and have files inherit from that
      work.visibility = visibility
      work.save
      InheritPermissionsJob.perform_now(work)

      # set work back to original visibility
      work.visibility = original_visibility
      work.save
    end

    #
    # Load input spreadsheet and verify visibility settings
    #
    # @param [String] csv_file  path to csv file
    #
    # @return [Array]
    #
    def get_csv(csv_file)
      x = 0
      rows = []
      csv = CSV.read(csv_file, headers: true)
      csv.each do |row|
        x += 1
        unless @visibility_options.include? row['visibility']
          raise 'Row ' + x.to_s + ' of ' + csv_file +
                ' contains invalid visibility option: ' + row['visibility']
        end
        rows << row
      end
      rows
    end

    private

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
