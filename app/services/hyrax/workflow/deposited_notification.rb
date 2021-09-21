
module Hyrax
  module Workflow
    class DepositedNotification < AbstractNotification
      private

      def subject
        'Your submission has been posted'
      end

      def message
        handle = 'http://hdl.handle.net/' + ENV['HS_PREFIX'] + '/' + work_id
        text = "#{title} (#{link_to work_id, document_path}) was approved by " \
               "#{user.name} (#{user.email}) and will be assigned the " \
               'permanent URL: ' + handle + "\n\n"
        text + comment
      end

      def users_to_notify
        user_key = ActiveFedora::Base.find(work_id).depositor
        super << ::User.find_by(email: user_key)
      end
    end
  end
 end
