# frozen_string_literal: true

require 'nokogiri'
require 'zip'

namespace :calstate do
  desc 'Fix missing DSpace data from Proquest SWORD XML'
  task proquest_fixer: :environment do
    input_dir = '/data/exported/unpacked'
    @namespaces = {
      xlink: 'http://www.w3.org/1999/xlink',
      mets: 'http://www.loc.gov/METS/',
      mods: 'http://www.loc.gov/mods/v3'
    }

    Dir.foreach(input_dir) do |file|
      next if ['.', '..'].include? file

      unpacked_dir = input_dir + '/' + file
      mets = unpacked_dir + '/mets.xml'

      next unless File.exist? mets

      dom = Nokogiri::XML(File.open(mets))

      # handle
      handle_path = '//mods:identifier[@type="uri"]'
      handle = dom.xpath(handle_path, @namespaces).first.text.to_s

      # check for sword file
      sword_dir = unzip_sword(dom, unpacked_dir)
      next if sword_dir.nil?

      # get missing data from native proquest xml file
      proquest_xml = get_proquest_xml_file(sword_dir)
      sword_xml_file = sword_dir + '/' + proquest_xml
      next unless File.exist? sword_xml_file

      record = get_proquest_attr(sword_xml_file)
      next unless record['complete']

      # get doc from fedora and update missing fields
      Thesis.where(handle: handle).each do |doc|
        doc.resource_type = [record['resource_type']]
        doc.extent = [record['extent']]
        doc.degree_level = [record['degree_type']]
        doc.department = [record['department']]
        doc.advisor = [record['advisor']]
        doc.subject = record['disciplines']
        doc.committee_member = record['committe_members']
        doc.keyword = record['keywords']

        puts doc.id.to_s + ': ' + doc.title.first.to_s
        doc.save
      end
    end
  end
end

#
# Extract missing attributes from Proquest XML
#
# @param [String] sword_mets_file  path to sword mets file
#
# @return [Hash]
#
def get_proquest_attr(sword_mets_file)
  dom = Nokogiri::XML(File.open(sword_mets_file))
  dom.remove_namespaces!
  dissertation = dom.xpath('//DISS_submission').first

  record = {}
  return record if dissertation.nil?

  record['keywords'] = []
  record['disciplines'] = []
  record['committe_members'] = []

  keyword_list = dissertation.xpath('//DISS_keyword').first.text
  keyword_list.split(',').each do |keyword|
    record['keywords'] << keyword.strip
  end

  dissertation.xpath('//DISS_category/DISS_cat_desc').each do |discipline|
    record['disciplines'] << discipline.text
  end

  dissertation.xpath('//DISS_cmte_member/DISS_name').each do |member|
    record['committe_members'] << format_name(member)
  end

  type = dissertation.xpath('//DISS_description/@type').first.value.to_s
  record['resource_type'] = type == 'doctoral' ? 'Dissertation' : 'Thesis'

  extent = dissertation.xpath('//DISS_description/@page_count').first.value.to_s
  record['extent'] = extent.nil? ? '' : extent + ' pages'

  record['degree_type'] = dissertation.xpath('//DISS_degree').first.text
  record['department'] = dissertation.xpath('//DISS_inst_contact').first.text
  record['advisor'] = format_name(dissertation.xpath('//DISS_advisor/DISS_name').first)
  record['complete'] = true

  record
end

#
# Unzip the original SWORD package
#
# @param [Nokogiri::XML::Document] dom  xml file
# @param [String] unpacked_dir          path of unpacked item directory
#
# @return [String|Nil] path to sword directory, or nil if it didn't work
#
def unzip_sword(dom, unpacked_dir)
  sword_path = '//mets:fileGrp[@USE="SWORD"]/mets:file/mets:FLocat/@xlink:href'
  sword_list = dom.xpath(sword_path, @namespaces)
  return nil if sword_list.count < 1

  sword_zip = sword_list.first.value.to_s
  sword_dir = unpacked_dir + '/sword'
  result = unzip_pq_package(unpacked_dir + '/' + sword_zip, sword_dir)
  return nil unless result == true

  sword_dir
end

#
# File containing native Proquest XML document
# Sometimes it's buried in mets.xml, sometimes in a separate file
#
# @param [String] sword_dir  item's unpacked sword directory
#
# @return [String] file containing native Proquest XML
#
def get_proquest_xml_file(sword_dir)
  proquest_xml = 'mets.xml'
  Dir.foreach(sword_dir) do |sword_file|
    next unless sword_file.include?('.xml')
    next if sword_file == 'mets.xml'

    proquest_xml = sword_file
  end
  proquest_xml
end

#
# Format the name element as last, first middle
#
# @param [Nokogiri::XML::Element] name  the DISS_name node
#
# @return [String] name formatted as "last, first middle"
#
def format_name(name)
  surname = name.xpath('DISS_surname').first.text.to_s
  fname = name.xpath('DISS_fname').first.text.to_s
  middle = name.xpath('DISS_middle').first.text.to_s
  name = surname + ', ' + fname + ' ' + middle
  name.strip
end

#
# Unzip a package
#
# @param [String] zip_file    path to zip file
# @param [String] output_dir  path to directory to unzip it into
#
# @return [Boolean]  true if successful, false if not
#
def unzip_pq_package(zip_file, output_dir)
  unless File.exist?(zip_file)
    puts zip_file + ' not found.'
    return false
  end

  # we already did this one
  return true if Dir.exist?(output_dir)

  # create a new directory
  Dir.mkdir output_dir

  # extract contents of zip file
  Zip::File.open(zip_file) do |zipfile|
    zipfile.each do |f|
      fpath = File.join(output_dir, f.name)
      zipfile.extract(f, fpath) unless File.exist?(fpath)
    end
  end

  true
end
