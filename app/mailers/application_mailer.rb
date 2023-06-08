#
# document_url
#
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def document_url
    key = document.model_name.singular_route_key
    Rails.application.routes.url_helpers.send(key + "_url", document.id)
  end
end
