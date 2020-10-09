# frozen_string_literal: true

require 'calstate/metadata'
require 'pp'

namespace :calstate do
  desc 'Metadata fixer'
  task metadata_fixer: :environment do
    sanfrancisco_visibility
  end

  def sanfrancisco_visibility
    csv_file = '/home/ec2-user/data/exported/sanfrancisco_thesis.csv'
    query = {
      visibility: 'private',
      embargo_release_date: nil
    }

    csv = CalState::Metadata::Csv::Reader.new(csv_file)
    csv.query(query).each do |row|
      puts 'Final: ' + row['title']
    end
  end

  def dspace_example
    file = '/home/ec2-user/data/dspace/sacramento.csv'
    field_mapping = {
      title: 'dc.title'
    }
    dspace = CalState::Metadata::Dspace.new(file, field_mapping)
    CalState::Metadata.models.each do |model|
      model.where(campus: 'Sacramento').each do |doc|
        handle = doc.handle.first.to_s
        next unless dspace.records.key?(handle)

        puts dspace.records[handle][:title]
      end
    end
  end

  def fix_abstract(opts)
    dspace = CalState::Metadata::Dspace.new(opts['campus_file'], opts['field_mapping'])

    CalState::Metadata.models.each do |model|
      model.where(campus: opts['campus_name']).each do |doc|
        handle = doc.handle.first.to_s
        next unless dspace.records.key?(handle)

        notes = []
        abstract = []
        dspace_abstract = dspace.records[handle][:abstract]

        doc.abstract.each do |note|
          if note == dspace_abstract
            abstract << note
          else
            notes << note
          end
        end

        doc.abstract = abstract
        doc.description = notes
        # doc.save
      end
    end
  end

  def fix_missing_campus
    CalState::Metadata.models.each do |model|
      model.where(campus: nil).each do |doc|
        puts "\n\n"
        puts doc.id
        puts doc.title.first.to_s
        campus = get_campus_name(doc)
        puts campus
        doc.campus = [campus]
        # doc.save
      end
    end
  end

  def fix_chars(campus)
    fields = %w[title abstract creator contributor advisor committee_member editor
                college department degree_name publisher subject keyword]
    CalState::Metadata.models.each do |model|
      model.where(campus: campus).each do |doc|
        fields.each do |field|
          doc[field] = clean_field_array(doc[field])
        end
      end
    end
  end

  # extract the campus name from the admin set
  def get_campus_name(doc)
    admin_set = doc.admin_set.title.first.to_s
    Hyrax::CampusService.get_campus_from_admin_set(admin_set)
  end

  # remove migration-created character entities and extraneous spaces
  # from a field with array
  def clean_field_array(field)
    final = []
    field.each do |value|
      final << clean_field(value.to_s)
    end
    final
  end

  # remove migration-created character entities and extraneous spaces
  def clean_field(value)
    doc = Nokogiri::XML.fragment(value)
    doc.text.squish
  end
end
