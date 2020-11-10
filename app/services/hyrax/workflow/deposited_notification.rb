
module Hyrax
  module Workflow
    class DepositedNotification < AbstractNotification
      private

      def subject
        'Your submission has been posted'
      end

      def message
        text = "#{title} (#{link_to work_id, document_path}) was approved by " \
          "#{user.name} (#{user.email})"
        unless document.handle.to_s.empty?
          text += ' and has been assigned a permanent URL: ' +
            document.handle.to_s + "\n\n"
        end
        text + comment
      end

      def users_to_notify
        user_key = ActiveFedora::Base.find(work_id).depositor
        super << ::User.find_by(email: user_key)
      end
    end
  end
 end
