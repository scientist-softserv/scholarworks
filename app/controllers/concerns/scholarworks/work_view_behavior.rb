# frozen_string_literal: true

module Scholarworks
  module WorkViewBehavior
    extend ActiveSupport::Concern

    included do
      after_action :track_view, only: :show

      def track_view
        work_type = self.class
        stats_work_view = StatsWorkView.new(work_id: params[:id],
                                            ip_address: request.remote_ip,
                                            created_at: DateTime.now,
                                            user_agent: request.headers['User-Agent'])
        stats_work_view.save!
      end
    end
  end
end
