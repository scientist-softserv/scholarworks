# frozen_string_literal: true

#
# Build campus-specific forms
#
class WorkFormService
  #
  # Get form object for this model
  #
  # If there is a campus-specific version, return that
  #
  # @param current_user [User]                    current user
  # @param curation_concern [ActiveFedora::Base]  one of the models
  # @param current_ability [Ability]              current ability
  # @param *extra
  #
  # @return [Hyrax::Forms::WorkForm]
  #
  def self.build(current_user, curation_concern, current_ability, *extra)
    form_class(curation_concern, current_user).new(curation_concern, current_ability, *extra)
  end

  #
  # Get form class for this model
  #
  # If there is a campus-specific version, return that
  #
  # @param curation_concern [ActiveFedora::Base]  one of the models
  # @param current_user [User]                    [optional] current user
  #
  # @return [Hyrax::Forms::WorkForm]
  #
  def self.form_class(curation_concern, current_user = nil)
    # if the record has a campus already, use that
    # otherwise use the campus from current user
    campus = if !curation_concern.campus.empty?
               curation_concern.campus.first
             elsif !current_user.campus.nil?
               current_user.campus
             end
    campus_class = campus.to_s.sub(' ', '')

    # form object variations
    main_form = curation_concern.model_name.name + 'Form'
    campus_form = main_form + campus_class
    manager_form = main_form + 'Managers'
    campus_manager_form = manager_form + campus_class

    # take most customizable version of form over others
    form = if Hyrax.const_defined?(campus_manager_form) && current_user.manager?
             Hyrax.const_get(campus_manager_form)
           elsif Hyrax.const_defined?(manager_form) && current_user.manager?
             Hyrax.const_get(manager_form)
           elsif Hyrax.const_defined?(campus_form)
             Hyrax.const_get(campus_form)
           else
             Hyrax.const_get(main_form)
           end

    Rails.logger.debug 'Form selection'
    Rails.logger.debug 'defined: ' + Hyrax.const_defined?(campus_manager_form).to_s
    Rails.logger.debug 'manager? ' + current_user.manager?.to_s
    Rails.logger.debug form

    form
  end
end
