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
  end
end
