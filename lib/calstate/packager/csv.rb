# frozen_string_literal: true

module CalState
  module Packager
    #
    # CSV importer
    #
    class Csv < AbstractPackager
      #
      # New Csv packager
      #
      # @param campus [String]  campus slug
      #
      def initialize(campus)
        super campus
      end

      #
      # Process all items
      #
      # @param path [String]  full path to csv file
      #
      def process_items(path)
        @log.info 'Processing all items.'

        x = 0
        base_path = File.dirname(path)

        csv = CalState::Metadata::Csv::Reader.new(path)
        @transaction = CalState::Packager::CsvTransaction.new(csv)

        records = csv.records
        records = map_fields(records) if @config['field_map']

        records.each do |record|
          @log.info 'Processing record: ' + x.to_s

          files = []
          if record.key?('files')
            record['files'].each do |file|
              files.append(base_path + '/' + file)
            end
          end
          x += 1
          next if @transaction.completed?(x)

          process_item(record.except('files'), files, counter: x)
        end
      end

      protected

      #
      # What to do on success
      #
      # @param record [Hash]  record attributes
      # @param files [Array]  file locations
      # @param args           other args to pass to error processing
      #
      def on_success(record, files, **args)
        counter = args[:counter]
        update_transaction(record['id'], counter, 'success')
      end

      #
      # What to do on error
      #
      # @param error [StandardError]  the error
      # @param record [Hash]          record attributes
      # @param files [Array]          file locations
      # @param args                   other args to pass to error processing
      #
      def on_error(error, record, files, **args)
        counter = args[:counter]
        update_transaction(record['id'], counter, 'error')
      end

      #
      # Update the transaction with status
      #
      # @param id [String]      record ID
      # @param pos [Integer]    record position
      # @param status [String]  result
      #
      def update_transaction(id, pos, status)
        record = @transaction.record(pos)
        record['id'] = id
        record['result'] = status
        @transaction.save
      end

      #
      # Map field names in CSV to our internal fields
      #
      # @param [Array<Hash>]  records from CSV
      #
      # @return [Array<Hash>]
      #
      def map_fields(records)
        raise 'No field map defined in config.' if @config['field_map'].blank?

        final = []
        records.each do |record|
          new_record = {}
          record.each do |field, value|
            next unless @config['field_map'].key?(field)

            mapped_field = @config['field_map'][field]

            if @config['separator'] && value.is_a?(Array) && value.present?
              value = value.first.split(@config['separator'])
              clean = []
              value.each do |part|
                clean.append part.strip
              end
              value = clean
            end

            if FieldService.single_fields.include?(mapped_field)
              if value.is_a?(Array)
                @log.warn "#{field} was multi-valued, but #{mapped_field} is single valued."
                new_record[mapped_field] = value.first
              else
                new_record[mapped_field] = value
              end
            else
              new_record[mapped_field] = [] unless new_record.key?(mapped_field)
              if value.is_a?(Array)
                new_record[mapped_field] += value
              else
                new_record[mapped_field].append value
              end
            end
          end
          final.append new_record
        end

        final
      end
    end
  end
end
