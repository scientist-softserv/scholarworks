#
# Custom type selector presenter so we can have campus-specific labels
#
module Hyrax
  class CampusSelectTypePresenter < SelectTypePresenter
    def initialize(concern, campus)
      @concern = concern
      @campus = campus
    end

    private

    def translate(key, default = nil)
      defaults = []
      defaults << :"hyrax.select_type.#{object_name}.#{@campus}.#{key}"
      defaults << default
      defaults << :"hyrax.select_type.#{object_name}.#{key}"
      defaults << :"hyrax.select_type.#{key}"
      defaults << ''
      I18n.t(defaults.shift, default: defaults)
    end
  end
end
