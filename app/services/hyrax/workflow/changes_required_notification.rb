module Hyrax
  module Workflow
    class ChangesRequiredNotification < AbstractNotification
      private

      def subject
        'Your deposit requires changes'
      end

      def message
        "#{title} (#{link_to work_id, document_path}) requires additional " \
          "changes before approval.\n\n '#{comment}'\n\n " \
          "Send any questions about this request to #{user.name} (#{user.email})"
      end

      def users_to_notify
        user_key = document.depositor
        super << ::User.find_by(email: user_key)
      end
    end
  end
end

