#
# Flexible campus-specific authorities
#
class AuthorityService < Hyrax::QaSelectService
  #
  # New Authority
  #
  # @param field [String]                      field name
  # @param controller [ApplicationController]  model-based controller
  #
  def initialize(field, controller)
    authority_name = get_campus_authority(field, controller)
    super(authority_name)
  end

  #
  # Fetch a local campus version of an authority file
  #
  # If it doesn't exist, supply the main version
  #
  # @param field [String]                      field name
  # @param controller [ApplicationController]  model-based controller
  #
  # @return [String]
  #
  def get_campus_authority(field, controller)
    campus = CampusService.get_campus_from_controller(controller)
    campus_file = 'config/authorities/' + field + '_' + campus + '.yml'
    if File.exist? campus_file
      field + '_' + campus
    else
      field
    end
  end
end
