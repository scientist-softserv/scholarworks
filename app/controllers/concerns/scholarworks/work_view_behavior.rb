# frozen_string_literal: true

module Scholarworks
  module WorkViewBehavior
    extend ActiveSupport::Concern

    included do
      after_action :track_view, only: :show

      def track_view
        # ignore bots, other weird requests & multiple views during same session
        return if StatsService.bad_user_agent?(request) || params[:id].nil?

        # we shouldn't record stat for new and edit actions
        return if request.env['HTTP_REFERER']&.end_with?('new') ||
                  request.env['HTTP_REFERER']&.end_with?('edit')

        stats = StatsWorkView.check_active(request.remote_ip, params[:id])
        return unless stats.empty?

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
