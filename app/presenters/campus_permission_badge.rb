#
# To accommodate campus
#
class CampusPermissionBadge < Hyrax::PermissionBadge
  private

  def dom_label_class
    VISIBILITY_LABEL_CLASS.fetch(@visibility.to_sym, 'label-info')
  end
end
