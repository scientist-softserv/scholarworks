# frozen_string_literal: true

require 'csv'
require 'pp'

namespace :calstate do
  desc 'Import metadata csv for a campus'
  task :import, %i[file] => [:environment] do |_t, args|
    # error check
    source_file = args[:file] or raise 'No import file provided.'

    # csv file to import
    csv_file = '/home/ec2-user/import/' + source_file
    csv = CSV.read(csv_file, { headers: true, encoding: 'bom|utf-8' })

    fields = Thesis.attribute_names
    tasks = {}

    csv.each do |row|
      begin
        id = clean_value(row['id'])
        doc = Thesis.find(id)
      rescue StandardError => e
        puts 'ERROR: ' + e.to_s
        next
      end

      task = []
      row.each do |key, value|
        next unless fields.include? key

        result = set_value(doc, key, value)
        task << result unless result.blank?
      end
      next if task.empty?

      puts "\n\n------------------------------"
      puts doc.id + ': ' + doc.title.first.to_s
      task.each do |message|
        puts message
      end

      tasks[id] = task
    end
  end

  # Ensure that any value we extract doesn't have illegal characters
  # including any we supplied in the export to trick excel
  #
  # @param value [String] the value to clean
  # @return [String] a nice shiny, clean value
  #
  def clean_value(value)
    return value if value.nil?

    value.squish
  end

  # Set the value in the Fedora document
  #
  # @param doc [ActiveFedora::Base] the fedora document
  # @param key [String] the field name
  # @param doc [String] the field value
  #
  def set_value(doc, key, value)
    field = doc[key]
    value = clean_value(value)
    return if field.blank? && value.blank?

    diff = nil # any difference

    if field.is_a?(ActiveTriples::Relation)
      field_values = relation_to_array(field)
      values = value.blank? ? [] : value.split('|')

      # values are the same or both are blank, so no change
      return if field_values.sort == values.sort
      return if field_values.join('|').blank? && values.join('|').blank?

      diff = Diffy::Diff.new(field_values.join('|') + "\n", values.join('|') + "\n")
    else
      return if field == value

      diff = Diffy::Diff.new(field + "\n", value + "\n")
    end

    return nil if diff.to_s.length.zero?

    key + ":\n" + diff.to_s
  end

  # Convert active triple relation to array
  #
  # @param field [ActiveTriples::Relation]
  # @return [Array]
  #
  def relation_to_array(field)
    values = []
    field.each do |part|
      values << part.to_s
    end
    values
  end
end
