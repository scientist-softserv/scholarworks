# frozen_string_literal: true

module Scholarworks
  module WorkViewBehavior
    extend ActiveSupport::Concern

    included do
      after_action :track_view, only: :show

      def track_view
        # ignore bots, other weird requests & multiple views during same session
        return if UserAgent.is_bad?(request)
        return unless session["stats_work_view_#{params[:id]}"].nil?

        # track visit in session and database
        session["stats_work_view_#{params[:id]}"] = true
        curation_concern = @curation_concern ? @curation_concern : _curation_concern_type.find(params[:id])
        stats_work_view = StatsWorkView.new(work_id: params[:id],
                                            ip_address: request.remote_ip,
                                            created_at: DateTime.now,
                                            campus: curation_concern.campus.first,
                                            user_agent: request.headers['User-Agent'])
        stats_work_view.save!
      end
    end
  end
end
