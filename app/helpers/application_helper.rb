module ApplicationHelper
  def render_discipline_name value
    DisciplineService::DISCIPLINES[value].nil? ? value : DisciplineService::DISCIPLINES[value].name
  end
end
