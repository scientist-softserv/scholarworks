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
        # @param log_loc [String]     path to log file directory
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
          total = @doc.xpath('//record').count
          completed = @doc.xpath('//record[@complete = "true"]').count
          records = @doc.xpath('//record[@complete = "false"]')
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

              print 'done!'

              completed += 1
              percent = (completed / total.to_f) * 100.0
              print "\t( " + format_number(completed) + ' of ' +
                    format_number(total) + ' | ' + percent.round(1).to_s + ' % )'
              print "\n"

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

            # throttle
            if (x % 20).zero?
              puts "\n shhhhh . . . sleeping!\n\n"
              sleep(150)
            end
          end
        end

        #
        # Format number with comma
        #
        # @param number [Numeric]
        #
        # @return [String]
        #
        def format_number(number)
          whole, decimal = number.to_s.split('.')
          num_groups = whole.chars.to_a.reverse.each_slice(3)
          whole_with_commas = num_groups.map(&:join).join(',').reverse
          [whole_with_commas, decimal].compact.join('.')
        end
      end
    end
  end
end
