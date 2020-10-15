# frozen_string_literal: true

require 'calstate/metadata'
require 'pp'

namespace :calstate do
  desc 'Make record public but keep files restricted'
  task split_visibility: :environment do

    CalState::Metadata.models.each do |model|
      model.all.each do |doc|
        no_embargo = doc.embargo_release_date.nil?
        next unless doc.visibility == 'restricted' && no_embargo

        doc.visibility = 'open'
        # doc.save
        puts doc.id.to_s + ':' + doc.title.first.to_s
      end
    end
  end
end
