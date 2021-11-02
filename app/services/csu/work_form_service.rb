
module Csu
  class WorkFormService
    def self.build(campus, curation_concern, current_ability, *extra)
      form_class(curation_concern, campus).new(curation_concern, current_ability, *extra)
    end

    #
    # Get form object for this model
    #
    # If there is a campus-specific version, return that
    #
    # @param [ActiveFedora::Base] curation_concern  one of the models
    # @param [String] campus                        [optional] campus slug
    #
    # @return [Hyrax::Forms::WorkForm]
    #
    def self.form_class(curation_concern, campus = nil)
      # if the record has a campus already, use that
      # otherwise use the supplied campus (from current user)

      if !curation_concern.campus.empty?
        campus = curation_concern.campus.first
      elsif !campus.nil?
        campus = ::Hyrax::CampusService.get_campus_name_from_id(campus)
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
end
