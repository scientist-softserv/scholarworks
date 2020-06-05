# frozen_string_literal: true

require 'pp'
require 'csv'

namespace :calstate do
  desc 'Metadata fixer'
  task metadata_fixer: :environment do
    find_duplicates('East Bay')
  end

  def print_record(id)
    Publication.where(id: id).each do |doc|
      pp doc
    end
  end

  def find_duplicates(campus)
    handles = []
    [Thesis, Publication, Dataset, EducationalResource].each do |model|
      model.where(campus: campus).each do |doc|
        handle = doc.handle.first.to_s
        title = doc.title.first.to_s
        if handles.include?(handle)
          puts handle + ': ' + title
        else
          handles << handle
        end
      end
    end
  end

  def fix_abstract(campus)

    from_dspace = load_dspace_csv('/home/ec2-user/dspace-data/' + campus + '.csv')

    [Thesis, Publication, Dataset, EducationalResource].each do |model|
      model.where(campus: campus).each do |doc|
        handle = doc.handle.first.to_s
        next unless from_dspace.key?(handle)

        notes = []
        abstract = []
        dspace_abstract = from_dspace[handle]['abstract']

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
    [Thesis, Publication, Dataset, EducationalResource].each do |model|
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
    [Thesis, Publication, Dataset, EducationalResource].each do |model|
      model.where(campus: campus).each do |doc|
        doc.title = clean_field_array(doc.title)
        doc.abstract = clean_field_array(doc.abstract)
        doc.creator = clean_field_array(doc.creator)
        doc.contributor = clean_field_array(doc.contributor)
        doc.advisor = clean_field_array(doc.advisor)
        doc.committee_member = clean_field_array(doc.committee_member)
        doc.editor = clean_field_array(doc.editor)
        doc.college = clean_field_array(doc.college)
        doc.department = clean_field_array(doc.department)
        doc.degree_name = clean_field_array(doc.degree_name)
        doc.publisher = clean_field_array(doc.publisher)
        doc.subject = clean_field_array(doc.subject)
        doc.keyword = clean_field_array(doc.keyword)

        puts "\n\n"
        pp doc
      end
    end
  end

  # convert a field to array
  def field_to_array(field)
    final = []
    field.each do |value|
      final << value.to_s
    end
    final
  end

  # extract all values from the same field in dspace
  # including all language variants
  def extract_values(row, field)
    values = []
    ['', '[]', '[en]', '[en_US]'].each do |attr|
      values << row[field + attr] unless row[field + attr].nil?
    end
    values
  end

  # extract a single value from (combined) dspace column
  def extract_single_value(row, field)
    values = extract_values(row, field)
    return nil unless values.count.positive?

    values.first
  end

  # load dspace metadata file
  # return Hash as handle => values
  def load_dspace_csv(csv_file, fields)
    final = {}
    table = CSV.parse(File.read(csv_file), headers: true)
    table.each do |row|
      values = {}
      fields.each do |hyrax_name, dspace_name|
        values[hyrax_name] = extract_single_value(row, dspace_name)
      end
      values['handle'] = extract_single_value(row, 'dc.identifier.uri')
      final[values['handle']] = values
    end
    final
  end

  # extract the campus name from the admin set
  def get_campus_name(doc)
    admin_set = doc.admin_set.title.first.to_s
    Hyrax::CampusService.get_campus_from_admin_set(admin_set)
  end

  # construct the url to the item based on id and type
  def get_url(doc, type)
    id = doc.id.to_s
    'https://scholarworks.calstate.edu/concern/' + type + '/' + id
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
