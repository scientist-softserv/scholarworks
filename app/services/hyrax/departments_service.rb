module Hyrax
  module DepartmentsService
    mattr_accessor :authority
    self.authority = Qa::Authorities::Local.subauthority_for('departments')

    def self.select_options(controller, form)
      campus = Hyrax::CampusService.get_campus_from_form(controller, form)
      campus = campus.downcase.gsub(' ', '_')

      model = model_name(controller)
      file_name = 'config/authorities/departments_' + campus + '_' + model + '.yml'

      subauthority = if File.exist? file_name
                       'departments_' + campus + '_' + model
                     else
                       'departments_' + campus
                     end

      campus_authority = Qa::Authorities::Local.subauthority_for(subauthority)

      campus_authority.all.map do |element|
        [element[:label], element[:id]]
      end
    end

    def self.label(id)
      authority.find(id).fetch('term')
    end

    ##
    # @param [String, nil] id identifier of the resource type
    #
    # @return [String] a schema.org type. Gives the default type if `id` is nil.
    def self.microdata_type(id)
      return Hyrax.config.microdata_default_type if id.nil?
      Microdata.fetch("resource_type_thesis.#{id}", default: Hyrax.config.microdata_default_type)
    end

    def self.model_name(controller)
      name = controller.class.name
      name.sub!('Hyrax::', '')
      name.sub!('Controller', '')

      name.downcase
    end
  end
end
