# frozen_string_literal: true

require 'csv'
require 'pp'

namespace :calstate do
  desc 'Export metadata csv for a campus'
  task :import, %i[file] => [:environment] do |_t, args|
    # error check
    source_file = args[:file] or raise 'No import file provided.'

    # csv file to import
    csv_file = '/home/ec2-user/import/' + source_file
    csv = CSV.parse(File.read(csv_file), headers: true)
    fields = Thesis.attribute_names

    csv.each do |row|
      doc = Thesis.find(row['id'])
      tasks = []
      row.each do |key, value|
        next unless fields.include? key

        result = set_value(doc, key, value)
        tasks << result unless result.blank?
      end
      next if tasks.empty?

      puts "\n\n------------------------------"
      puts doc.id + ': ' + doc.title.first.to_s
      tasks.each do |message|
        puts "\t" + message
      end
    end
  end

  def set_value(doc, key, value)
    field = doc[key]
    return if field.blank? && value.blank?

    if field.is_a?(ActiveTriples::Relation)
      field_values = relation_to_array(field)
      values = value.blank? ? [] : value.split('|')

      # values are the same or both are blank, so no change
      return if field_values.sort == values.sort
      return if field_values.join('|').blank? && values.join('|').blank?

      '[' + key + '] will be changed from ' \
      '[' + field_values.join('|') + '] to ' \
      '[' + values.join('|') + ']'
    else
      return if field == value

      '[' + key + '] will be changed from ' \
      '[' + field + '] to [' + value + ']'
    end
  end

  def relation_to_array(field)
    values = []
    field.each do |part|
      values << part.to_s
    end
    values
  end
end
