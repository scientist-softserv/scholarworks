# frozen_string_literal: true

require 'pp'

namespace :hyrax do
  desc 'Create a rewrite map of handles to hyrax ids'
  task handle_mapper: :environment do
    Thesis.all.each do |doc|
      write_to_file(doc, 'theses')
    end

    Publication.all.each do |doc|
      write_to_file(doc, 'publications')
    end

    EducationalResource.all.each do |doc|
      write_to_file(doc, 'educational_resources')
    end
  end

  # write the mapping to the appropriate campus file
  def write_to_file(doc, type)
    handle = doc.handle.first.to_s
    id = doc.id.to_s
    url = 'https://scholarworks.calstate.edu/concern/' + type + '/' + id
    campus = get_campus_id(doc)

    puts campus + ': ' + id

    return if handle.blank?

    File.open('/home/ec2-user/handles/' + campus + '.conf', 'a') do |f|
      f.puts get_rewrite_rule(handle, url)
    end
  end

  # extracts the campus name from the record and converts it into
  # a standard format suitable for a file name
  def get_campus_id(doc)
    # get campus name from the record
    campus = doc.campus.first

    # nada? get it from admin set
    if campus.blank?
      admin_set = doc.admin_set.title.first.to_s
      campus = Hyrax::CampusService.get_campus_from_admin_set(admin_set)
    end

    # did it this way because of Frozen errors
    id = campus.downcase
    id.sub(' ', '_')
  end

  # rewrite rule suitable for dspace apache
  def get_rewrite_rule(handle, url)
    handle = handle.sub('http://hdl.handle.net/', '')
    'RewriteRule /handle/' + handle + ' ' + url
  end
end
