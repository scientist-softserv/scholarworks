
#
# robots.txt controller
#
class RobotsController < ActionController::Base
  #
  # Send back server-specific robots.txt content
  #
  def index
    content = if ENV['SCHOLARWORKS_HOST'] == 'scholarworks.calstate.edu'
                'Sitemap: https://scholarworks.calstate.edu/sitemap/sitemap.xml'
              else
                "User-agent: * \n Disallow: /"
              end
    render plain: content
  end
end
