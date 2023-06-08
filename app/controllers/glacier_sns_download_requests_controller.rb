#
# Controller to handle aws Glacier download
#
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

    event_type = params["Message"]["Records"].first["eventName"] 
    s3_key = params["Message"]["Records"].first["s3"]["object"]["key"]

    request = GlacierSnsDownloadRequest.last
    request.update_attribute(:is_complete, true) # triggers email
    head 200
  end
end
