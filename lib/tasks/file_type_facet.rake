# frozen_string_literal: true

require 'calstate/metadata'

# Populate file type into work from files for works that have attachment but file_type is empty
# Usage:
# bundle exec rake calstate:file_type_facet

namespace :calstate do
  desc 'Populate file type into work from attached files
  task file_type_facet: :environment do

    CalState::Metadata.models.each do |model|
      model.where(file_type: '').each do |work|
        changes = {}
        work.file_sets.each do |file|
          file_type = FileService.type(file.title.first)
          if changes['file_type'].nil?
            changes['file_type'] = [file_type]
          else
            changes['file_type'] << file_type
          end
        end
        work.update(changes)
        work.save
      end
    end
  end
end
