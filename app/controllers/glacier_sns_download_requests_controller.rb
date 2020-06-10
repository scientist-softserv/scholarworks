class GlacierSnsDownloadRequestsController < ApplicationController
  def create
    download_request = current_user.glacier_sns_download_requests.create(glacier_identifier: params[:glacier_identifier])
    if download_request.valid?
      render json: download_request, status: 201
    else
      render json: download_request.errors, status: 422
    end
  end
end
