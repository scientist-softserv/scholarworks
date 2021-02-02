# frozen_string_literal: true

require 'calstate/metadata'

# Usage
# bundle exec rake calstate:visibility_split
# bundle exec rake calstate:visibility_split[sacramento]

namespace :calstate do
  desc 'Make record public but keep files restricted'
  task :visibility_split, %i[campus] => [:environment] do |_t, args|
    campus = args[:campus] ||= nil
    name = if campus.nil?
             nil
           else
             Hyrax::CampusService.get_campus_name_from_id(campus)
           end

    CalState::Metadata.models.each do |model|
      results = campus.nil? ? model.all : model.where(campus: name)
      results.each do |doc|
        no_embargo = doc.embargo_release_date.nil?
        next unless doc.visibility == 'restricted' && no_embargo

        doc.visibility = 'open'
        doc.save
        puts doc.id.to_s + ':' + doc.title.first.to_s
      end
    end
  end
end
