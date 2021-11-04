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
  # @param campus [String]                        campus id
  # @param curation_concern [ActiveFedora::Base]  one of the models
  # @param current_ability [Ability]              current ability
  # @param *extra
  #
  # @return [Hyrax::Forms::WorkForm]
  #
  def self.build(campus, curation_concern, current_ability, *extra)
    form_class(curation_concern, campus).new(curation_concern, current_ability, *extra)
  end

  #
  # Get form class for this model
  #
  # If there is a campus-specific version, return that
  #
  # @param curation_concern [ActiveFedora::Base]  one of the models
  # @param campus [String]                        [optional] campus slug
  #
  # @return [Hyrax::Forms::WorkForm]
  #
  def self.form_class(curation_concern, campus = nil)
    # if the record has a campus already, use that
    # otherwise use the supplied campus (from current user)
    if !curation_concern.campus.empty?
      campus = curation_concern.campus.first
    elsif !campus.nil?
      campus = ::CampusService.get_campus_name_from_id(campus)
    end

    # form object names
    main_class = curation_concern.model_name.name + 'Form'
    campus_class = main_class + campus.to_s.sub(' ', '')

    # if custom campus form object exists, return that
    # otherwise, return the main form for this model
    if Hyrax.const_defined?(campus_class)
      Hyrax.const_get(campus_class)
    else
      Hyrax.const_get(main_class)
    end
  end
end
