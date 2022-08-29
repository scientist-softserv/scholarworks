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
    authority_name = get_campus_authority(field, controller, model)
    super(authority_name)
  end

  #
  # Fetch a local campus version of an authority file
  #
  # If it doesn't exist, supply the main version
  #
  # @param field [String]                field name
  # @param controller [WorksController]  works controller
  # @param use_model [Boolean]           also check for model sub-authority
  #
  # @return [String]
  #
  def get_campus_authority(field, controller, use_model)
    campus = CampusService.get_campus_from_controller(controller)
    model = if controller.class.method_defined?(:curation_concern)
              controller.curation_concern.class.name.downcase
            else
              'collection'
            end
    return field if campus.blank?

    base = 'config/authorities/' + field
    campus_model_file = base + '_' + model + '_' + campus + '.yml'
    campus_model_alt = base + '_' + campus + '_' + model + '.yml'
    campus_file = base + '_' + campus + '.yml'
    model_file = base + '_' + model + '.yml'

    authority = if File.exist?(campus_model_file) && use_model
                  field + '_' + model + '_' + campus
                elsif File.exist?(campus_model_alt) && use_model
                  field + '_' + campus + '_' + model
                elsif File.exist?(model_file) && use_model
                  field + '_' + model
                elsif File.exist? campus_file
                  field + '_' + campus
                else
                  field
                end

    Rails.logger.debug 'Looking for: ' + campus_model_file if use_model
    Rails.logger.debug '   and also: ' + campus_model_alt if use_model
    Rails.logger.debug '   and also: ' + campus_file
    Rails.logger.debug '   and also: ' + model_file if use_model
    Rails.logger.debug 'Resulted in: ' + authority

    authority
  end
end
