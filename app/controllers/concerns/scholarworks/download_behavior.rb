# frozen_string_literal: true

module Scholarworks
  module DownloadBehavior
    extend ActiveSupport::Concern

    included do
      # use track_file_download since we already have track_download in DownloadAnalyticsBehavior
      after_action :track_file_download, only: :show

      def track_file_download
        # ignore thumbnail download of the file in the work detail page
        return if request.url.end_with?('file=thumbnail')

        f_obj = ActiveFedora::Base.find(params['id'])
        stats_file_download = StatsFileDownload.new(file_id: params[:id],
                                                    work_id: f_obj.parent.id,
                                                    ip_address: request.remote_ip,
                                                    created_at: DateTime.now,
                                                    user_agent: request.headers['User-Agent'])
        stats_file_download.save!
      end
    end
  end
end
