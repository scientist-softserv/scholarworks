# frozen_string_literal: true

require_relative 'packager/abstract_packager'
require_relative 'packager/csv'
require_relative 'packager/csv_transaction'
require_relative 'packager/dspace'
require_relative 'packager/exceptions'
require_relative 'packager/harvest'
require_relative 'packager/islandora'
require_relative 'packager/log'
require_relative 'packager/proquest'
require_relative 'packager/visibility'
require_relative 'packager/zenodo'


module CalState
  #
  # Migration classes and methods
  #
  module Packager
    #
    # Add the manager group to the record (work or file)
    #
    # @param work [ActiveRecord::Base]  Fedora record
    # @param campus [String]            campus slug
    #
    # @return [ActiveRecord::Base]
    #
    def self.add_manager_group(record, campus)
      group = 'managers-' + campus
      record.edit_groups = [group]
      record
    end

    #
    # Add the manager group to work and file
    #
    # @param work [ActiveRecord::Base]
    # @param campus [String]            campus slug
    #
    # @return [ActiveRecord::Base]
    #
    def self.add_manager_group_to_work(work, campus)
      work = add_manager_group(work, campus)
      work.save
      work.file_sets.each do |file_set|
        add_manager_group(file_set, campus)
        file_set.save
      end
    end

    #
    # Add work to collection
    #
    # @param work [ActiveFedora::Base]  work
    # @param collections [Array]        collection id's
    #
    def self.add_to_collection(work, collections)
      id = work.id
      collections.each do |coll|
        collection = Collection.find(coll)
        collection.reindex_extent = Hyrax::Adapters::NestingIndexAdapter::LIMITED_REINDEX
        collection.add_member_objects(id)
      end
    end

    #
    # Create a directory
    # only if it doesn't already exist
    #
    # @param dir [String]
    #
    # @return [String] the new directory
    #
    def self.initialize_directory(dir)
      Dir.mkdir(dir) unless Dir.exist?(dir)
      dir
    end

    #
    # Update visibility on work and files
    #
    # @param work [ActiveFedora::Base]   Fedora work
    # @param work_visibility [String]    visibility for work
    # @param file_visibility [String]    [optional] visibility for file
    #
    # @return [FalseClass]
    #
    def self.update_visibility(work, work_visibility, file_visibility = nil?)
      # this is ugly, but couldn't find a more efficient way to do this,
      # especially for campus visibility which behaves differently

      if work_visibility != file_visibility && file_visibility.present?
        # set work to file visibility so files can inherit from that
        work.visibility = file_visibility
        work.save
        VisibilityCopyJob.perform_now(work)

        # then set work to work visibility
        work.visibility = work_visibility
        work.save
      else
        work.visibility = work_visibility
        work.save
        VisibilityCopyJob.perform_now(work)
      end
    end

    #
    # Download an S3 File to local tmp dir
    #
    # @param s3_file [String]       path to s3 location
    # @param download_dir [String]  [optional] tmp path on local server to download the file
    #
    # @return [String] full path to local location of file
    #
    def self.download_s3_file(s3_file, download_dir = '/home/ec2-user/data/tmp/')
      filepath = s3_file.gsub('s3://', '')
      file_parts = filepath.split('/')
      bucket = file_parts.shift
      raise "Your s3_path `#{s3_file}` appears to be malformed." if bucket.nil?
      remote_path = file_parts.join('/')
      download_file = download_dir + file_parts.pop
      if Aws::S3::Resource.new.bucket(bucket).object(remote_path).download_file(download_file)
        download_file
      else
        raise "Could not download `#{s3_file}` to #{download_dir}"
      end
    end
  end
end
