#
# robots.txt controller to send back server-specific robots.txt content.
#
class RobotsController < ActionController::Base
  def index
    content = if SystemService.production?
                ['User-agent: GPTBot',
                 'Disallow: /',
                 "Sitemap: https://#{ENV['SCHOLARWORKS_HOST']}/sitemap/sitemap.xml"]
              else
                ['User-agent: *',
                 'Disallow: /']
              end
    render plain: content.join("\n")
  end
end
