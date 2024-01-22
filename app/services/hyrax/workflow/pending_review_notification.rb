# frozen_string_literal: true
#
# OVERRIDE class from hyrax v2.9.6
# Customization: Change subject and message
#
module Hyrax
  module Workflow
    class PendingReviewNotification < AbstractNotification
      private

      def subject
        'Your submission has been received'
      end

      def message
        "#{title} (#{link_to work_id, document_path}) was submitted by " \
          "#{user.name} (#{user.email}) and is awaiting approval.\n\n" +
          comment
      end

      def users_to_notify
        super << user
      end
    end
  end
end
