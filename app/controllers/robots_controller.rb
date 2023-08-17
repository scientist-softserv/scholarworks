#
# robots.txt controller to send back server-specific robots.txt content.
#
class RobotsController < ActionController::Base
  def index
    content = if SystemService.production?
                "Sitemap: https://#{ENV['SCHOLARWORKS_HOST']}/sitemap/sitemap.xml"
              else
                "User-agent: * \n Disallow: /"
              end
    render plain: content
  end
end
