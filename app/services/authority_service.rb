# frozen_string_literal: true

#
# Abstract class for campus-specific authorities
#
class AuthorityService < Hyrax::QaSelectService
  #
  # New Authority
  #
  # @param field [String]                field name
  # @param controller [WorksController]  works controller
  # @param model [Boolean]               also check for model sub-authority
  #
  def initialize(field, controller, model = false)
    authority_name = if model
                       get_campus_model_authority(field, controller)
                     else
                       get_campus_authority(field, controller)
                     end
    super(authority_name)
  end

  #
  # Fetch a local campus version of an authority file
  #
  # If it doesn't exist, supply the main version
  #
  # @param field [String]                field name
  # @param controller [WorksController]  works controller
  #
  # @return [String]
  #
  def get_campus_authority(field, controller)
    campus = CampusService.get_campus_from_controller(controller)
    if campus.blank?
      campus_file = 'config/authorities/' + field + '.yml'
    else
      campus_file = 'config/authorities/' + field + + '_' + campus + '.yml'
    end
    if File.exist? campus_file
      field + '_' + campus
    else
      field
    end
  end

  #
  # Fetch a local campus + model version of an authority file
  #
  # If it doesn't exist, supply the main (or just campus) version
  #
  # @param field [String]                field name
  # @param controller [WorksController]  works controller
  #
  # @return [String]
  #
  def get_campus_model_authority(field, controller)
    authority_name = get_campus_authority(field, controller)
    model = controller.curation_concern.class.name.downcase
    model_file = 'config/authorities/' + authority_name + '_' + model + '.yml'
    if File.exist? model_file
      authority_name + '_' + model
    else
      authority_name
    end
  end
end
