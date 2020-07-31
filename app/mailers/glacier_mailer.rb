class GlacierMailer < ApplicationMailer
  default from: "library@calstate.edu"

  def unarchive_complete_email user, location
    @user = user
    @location = location
    
    mail(to: @user.email, subject: "Glacier Archive ready for download")
  end
end
