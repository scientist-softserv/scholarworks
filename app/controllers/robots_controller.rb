
#
# robots.txt controller
#
class RobotsController < ActionController::Base
  #
  # Send back server-specific robots.txt content
  #
  def index
    content = if SystemService.production?
                "Sitemap: https://#{ENV['SCHOLARWORKS_HOST']}/sitemap/sitemap.xml"
              else
                "User-agent: * \n Disallow: /"
              end
    render plain: content
  end
end
