class GlacierSnsDownloadRequestsController < ApplicationController
  def create
    download_request = current_user.glacier_sns_download_requests.create(s3_key: params[:s3_key])
    if download_request.valid?
      render json: download_request, status: 201
    else
      render json: download_request.errors, status: 422
    end
  end

  def unarchive_complete_sns
    # ????? Unsure what the SNS looks like until we get to staging
    request = GlacierSnsDownloadRequest.last
    request.update_attribute(:is_complete, true) # triggers email
  end
end
