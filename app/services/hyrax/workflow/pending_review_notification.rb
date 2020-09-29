# frozen_string_literal: true

module Hyrax
  module Workflow
    class PendingReviewNotification < AbstractNotification
      private

      def subject
        'Deposit needs review'
      end

      def message
        "#{title} (#{link_to work_id, document_path}) was deposited by " \
          "#{user.name} (#{user.email}) and is awaiting approval " +
          comment
      end

      def users_to_notify
        super << user
      end
    end
  end
end
