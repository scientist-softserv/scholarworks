# frozen_string_literal: true

require 'pp'
require 'csv'

namespace :calstate do
  desc 'Metadata fixer'
  task reset: :environment do
    remove_items('San Francisco')
  end

  def remove_items(campus)
    [Thesis, Publication, Dataset, EducationalResource].each do |model|
      model.where(campus: campus).each.each do |doc|
        title = doc.title.first.to_s
        campus = doc.campus.first.to_s
        puts campus + ': ' + title
        doc.destroy
      end
    end
  end
end
