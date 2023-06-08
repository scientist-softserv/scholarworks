#
# OVERRIDE class from Hyrax v2.9.6
# Customization:  Change subject and message
#
module Hyrax
  module Workflow
    class ChangesRequiredNotification < AbstractNotification
      private

      def subject
        'Your submission requires changes'
      end

      def message
        "#{title} (#{link_to work_id, document_path}) requires changes " \
          "before approval.\n\n '#{comment}'\n\n " \
          "Questions? Contact #{user.name} (#{user.email})"
      end

      def users_to_notify
        user_key = document.depositor
        super << ::User.find_by(email: user_key)
      end
    end
  end
end

