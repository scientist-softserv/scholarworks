# frozen_string_literal: true

require 'csv'
require 'nokogiri'

module CalState
  module Metadata
    module Csv
      #
      # Compares old and new metadata files and creates a transaction file
      #
      class Transaction
        include Utilities
        #
        # New transaction
        #
        # @param old_records_file [String]  path to dir with current metadata files
        # @param new_records_file [String]  path to dir with new metadata files
        #
        def initialize(old_records_file, new_records_file)
          @old_records_file = old_records_file
          @new_records_file = new_records_file

          # load the old metadata records into memory
          @xml = create_xml
        end

        #
        # Get XML transaction file
        #
        # @return [String]
        #
        def to_xml
          @xml.to_xml
        end

        #
        # Get HTML report from transaction file
        #
        # @return [String]  html
        #
        def to_html
          xslt_path = "#{File.dirname(__FILE__)}/xslt/template.xslt"
          xslt = Nokogiri::XSLT(File.read(xslt_path))
          xslt.transform(@xml)
        end


        private

        #
        # Create XML transaction file
        #
        def create_xml
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.transaction {
              xml.file @new_records_file
              xml.timestamp Time.now.utc.iso8601
              xml.date Time.now.strftime('%m/%d/%Y')
              xml.records {
                new_records.each do |id, new_record|
                  next unless old_records.key?(id)

                  record = record_changes(id, old_records[id], new_record)

                  next if  record[:changes].empty?

                  xml.record(id: id, complete: false) {
                    record[:changes].each do |change|
                      xml.change(field: change[:field]) {
                        %i[old new].each do |type|
                          if change[type].is_a?(Array)
                            xml.value(type: type, multi: true) {
                              change[type].each do |part|
                                xml.part part
                              end
                            }
                          else
                            xml.value(change[type], type: type)
                          end
                        end
                      }
                    end
                  }
                end
              }
            }
          end

          Nokogiri::XML::Document.parse(builder.to_xml)
        end

        #
        # Determine if record has changes and return those
        #
        # @param id [String]        record identifier
        # @param old_record [Hash]  old metadata record
        # @param new_record [Hash]  new metadata record
        #
        # @return [Hash]
        #
        def record_changes(id, old_record, new_record)
          record = {
            id: id,
            changes: []
          }
          new_record.each do |field, value|
            next if field.nil?
            next if field.empty?
            next if value.nil? && old_record[field].nil?
            next if are_same?(field, old_record[field], value)

            change = {
              field: field,
              old: old_record[field],
              new: value
            }

            record[:changes].append change
          end

          record
        end

        #
        # @return [Boolean]
        #
        def are_same?(field, old, new)
          if old.is_a?(Array) && new.is_a?(Array)
            unless FieldService.person_fields.include?(field)
              old.sort!
              new.sort!
            end
          end

          old == new
        end

        #
        # New metadata records
        #
        # @return [Hash]
        #
        def new_records
          @new_records = load_file(@new_records_file) if @new_records.nil?
          @new_records
        end

        #
        # Old (current) metadata records
        #
        # @return [Hash]
        #
        def old_records
          @old_records = load_file(@old_records_file) if @old_records.nil?
          @old_records
        end

        #
        # Load CSV file
        #
        # @param path [String]  path to file(s)
        # @return [Hash]
        #
        def load_file(path)
          records = {}

          Dir[path].each do |file|
            reader = Reader.new(file)

            reader.records.each do |record|
              records[record['id']] = record
            end
          end

          records
        end
      end
    end
  end
end
