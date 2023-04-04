# frozen_string_literal: true

require 'calstate/metadata'

# Usage:
# bundle exec rake calstate:metadata_transaction[eastbay_thesis]
# bundle exec rake calstate:metadata_transaction[fix]

namespace :calstate do
  desc 'Import metadata csv for a campus'
  task :metadata_transaction, %i[file] => [:environment] do |_t, args|
    file = args[:file] or raise 'No file specified.'

    old_dir = '/home/ec2-user/data/exported'
    new_dir = '/home/ec2-user/data/import'
    transaction_dir = "#{new_dir}/transactions"
    report_dir = '/data/exports/reports/'

    new_file = "#{new_dir}/#{file}.csv"
    old_file = if file == 'fix'
                 "#{old_dir}/*.csv"
               else
                 "#{old_dir}/#{file}*.csv"
               end

    trans = CalState::Metadata::Csv::Transaction.new(old_file, new_file)

    # create transaction file
    File.write("#{transaction_dir}/#{file}.xml", trans.to_xml)

    # create html report
    File.write("#{report_dir}/#{file}.html", trans.to_html)
  end
end
