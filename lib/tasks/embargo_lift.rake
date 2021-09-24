# frozen_string_literal: true

require 'calstate/metadata'

namespace :calstate do
  desc 'Metadata fixer'
  task embargo_lift: :environment do

    results = []

    results.each do |row|
      id = row['id'].squish
      work = ActiveFedora::Base.find(id)

      next if work.embargo.embargo_release_date.nil?

      print id + ': '

      if work.embargo.embargo_release_date <= Date.today
        print 'expired'
        work.deactivate_embargo!
      else
        print 'active'
        work.embargo.visibility_during_embargo = 'restricted'
      end

      print ' . . . '

      work.embargo.save!
      work.save!

      print "done!\n"
      sleep(10)
    end
  end
end
