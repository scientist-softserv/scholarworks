# frozen_string_literal: true

require 'csv'

# Usage
# remov

namespace :calstate do
  desc 'Metadata fixer'
  task delete_records: :environment do
    csv_file = '/home/ec2-user/data/remove.csv'
    options = { headers: true, encoding: 'bom|utf-8' }
    x = 0

    CSV.read(csv_file, options).each do |row|
      id = row['id']
      x += 1

      begin
        print "\n" + id + ' . . . '
        doc = ActiveFedora::Base.find(id)
        doc.destroy
        print 'deleted.'
      rescue ActiveFedora::ObjectNotFoundError
        print 'not found.'
      rescue Ldp::Gone
        print 'already deleted.'
      rescue Ldp::HttpError => e
        raise e unless e.message.include?('Cannot locate child node')

        print "couldn't locate child node."
      end
    end
  end
end
