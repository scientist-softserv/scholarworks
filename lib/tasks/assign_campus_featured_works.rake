# frozen_string_literal: true

# Usage:
# bundle exec rake calstate:assign_campus_featured_works
#
namespace :calstate do
  desc 'Assign campus to featured works'
  task assign_campus_featured_works: :environment do
    works = FeaturedWork.all
    works.each do |work|
      object = ::ActiveFedora::Base.find(work.work_id)
      work.campus = object.campus.first
      work.save
      puts "after saving work id #{work.work_id} campus #{work.campus}"
    end
  end
end
