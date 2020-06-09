class GlacierSnsDownloadRequestsController < ApplicationController
  def create
    archive_id = params[:glacier_location]
    download_request = current_user.glacier_sns_download_request.create(glacier_location: archive_id)
    if download_request.valid?
      head :created
    else
      head :unprocessible_entity
    end
  end
end
