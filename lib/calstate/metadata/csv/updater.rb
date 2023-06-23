# frozen_string_literal: true

require 'nokogiri'

module CalState
  module Metadata
    module Csv
      #
      # CSV Updater
      #
      class Updater
        include Utilities
        include Metadata::Utilities

        #
        # CSV Updater
        #
        # @param path [String]   path to transaction xml file
        #
        def initialize(path)
          @path = path
          @doc = Nokogiri::XML(File.open(path))
        end

        #
        # Process the transaction file
        #
        def run
          @doc.xpath("//record[@complete = 'false']").each do |record|
            print "Updating #{record['id']} . . . "
            update_record(record)
            print "done!\n"
          end
        end

        #
        # Move the finished transaction file to archive
        #
        # renames file to include the timestamp
        #
        def archive_file
          timestamp = @doc.xpath('//timestamp').first.content
          new_path = @path.gsub('.xml', "_#{timestamp}.xml")
          File.rename(@path, new_path)
        end

        #
        # Find and update the record
        #
        # @param record [Hash]  record from the CSV file
        #
        def update_record(record)
          work = ActiveFedora::Base.find(record['id'].to_s)

          changes = {}
          record.xpath('change').each do |change|
            field = change['field']
            value = get_value(change)
            changes[field] = value
          end

          work.update(changes.except('collection'))
          work.save

          # add to collection
          Packager.add_to_collection(work, changes['collection']) if changes['collection']

          # mark as processed
          record['complete'] = 'true'
          File.write(@path, @doc.to_xml)
        end

        #
        # Extract the value(s) from the change node
        #
        # @param change [Nokogiri::XML]  node
        #
        # @return [Array|String]
        #
        def get_value(change)
          values = []
          if change.xpath("value[@type='new' and @multi='true']").count.positive?
            change.xpath("value[@type='new']/part").each do |part|
              values.append part.text.squish
            end
            values
          else
            change.xpath("value[@type='new']").first.text
          end
        end
      end
    end
  end
end
