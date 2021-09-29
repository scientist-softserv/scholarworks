# frozen_string_literal: true

module CalState
  module Metadata
    module Fixer
      #
      # Keep track of our big update
      #
      class Tracker
        #
        # New Tracker
        #
        # @param trans_file [String]   path to transaction file
        # @param log_file [String]     path to log file directory
        #
        def initialize(trans_file, log_loc)
          @doc = Nokogiri::XML(File.open(trans_file))
          @trans_file = trans_file
          @log_file = log_loc + 'all.log'
          @error_log = log_loc + 'error.log'
        end

        #
        # Run the update
        #
        def run
          records = @doc.xpath("//record[@complete = 'false']")
          x = 0

          # get each record that needs to be changed
          records.each do |record|
            x += 1
            print record['id'] + ' . . . '

            begin
              # make metadata changes
              change_record = ChangeRecord.new(record)
              change_record.save

              # update transaction file
              record['complete'] = 'true'
              File.write(@trans_file, @doc.to_xml)

              # completion log
              File.open(@log_file, 'a') do |f|
                f.puts record['id'] + "\t" + change_record.changes.inspect
              end

              print "done!\n"

            rescue Net::ReadTimeout => e
              raise e # stop if Fedora is down or something

            rescue StandardError => e
              # error log
              File.open(@error_log, 'a') do |f|
                f.puts record['id'] + "\t" + e.message
              end
              print 'ERROR!'
              sleep 60
            end

            # pause during work days
            # if CalState::Metadata.should_throttle(x, 3)
            #   puts "\n shhhhh . . . sleeping!\n\n"
            #   sleep(180)
            # end

            # throttle
            if (x % 30).zero?
              puts "\n shhhhh . . . sleeping!\n\n"
              sleep(120)
            end
          end
        end
      end
    end
  end
end
