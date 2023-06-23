#
# Helper to get discipline name from discipline id
#
module ApplicationHelper
  def render_discipline_name value
    DisciplineService::DISCIPLINES[value].nil? ? value : DisciplineService::DISCIPLINES[value].name
  end
end
