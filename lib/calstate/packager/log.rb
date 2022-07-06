# frozen_string_literal: true

module CalState
  module Packager
    #
    # Logger
    #
    class Log < ActiveSupport::Logger

      attr_reader :start_time, :datetime_format, :output_level

      def initialize(*args)
        @start_time = Time.now
        @datetime_format = '%Y-%m-%d %H:%M:%S'

        args[0] = 'log/packager.log'
        super

        self.formatter = proc do |severity, datetime, _progname, msg|
          "#{datetime.strftime(@datetime_format)} #{severity} #{msg}\n"
        end
      end

      def close
        end_time = Time.now
        duration = (end_time - @start_time) / 1.minute
        info "Duration: #{duration}"
        super
      end

      def info(str)
        print_and_flush(str)
        super
      end

      def warn(str)
        print_and_flush(str)
        super
      end

      def error(str)
        print_and_flush(str)
        super
      end

      def print_and_flush(str)
        puts str
      end
    end
  end
end
